require 'cancan-permits/permit/util'
require 'sugar-high/array'

module Permit
  class Base 
    attr_reader :ability
    attr_reader :strategy # this can be used to customize the strategy used by owns to determine ownership, fx to support alternative ORMs 

    attr_reader :user_permissions, :role_permissions

    def licenses *names
      names.to_strings.each do |name|         
        begin
          module_name = "#{name.camelize}License"
          clazz = module_name.constantize
        rescue
          raise "License #{module_name} is not defined"
        end

        begin
          clazz.new(self).enforce!
        rescue
          raise "License #{clazz} could not be enforced using #{self.inspect}"
        end
      end
    end

    def load_rules user
      load_role_rules
      load_user_rules user
    end

    def load_role_rules
      return if !role_permissions || role_permissions.permissions.empty?
      name ||= self.class.to_s.gsub(/Permit$/, "").underscore.to_s #ym
            
      return if role_permissions.permissions[name].nil?

      role_permissions.permissions[name].can_eval do |permission_statement|
        instance_eval permission_statement
      end 
      role_permissions.permissions[name].cannot_eval do |permission_statement|
        instance_eval permission_statement
      end
    end

    def load_user_rules user 
      return if !user_permissions || user_permissions.permissions.empty?
      raise "#load_user_rules expects the user to have an email property: #{user.inspect}" if !user || !user.respond_to?(:email) 

      id = user.email
      return nil if id.strip.empty? || user_permissions.permissions[id].nil?

      user_permissions.permissions[id].can_eval do |permission_statement|
        instance_eval permission_statement
      end 
      user_permissions.permissions[id].cannot_eval do |permission_statement|
        instance_eval permission_statement
      end 
    end
       
    def initialize ability, options = {}
      @ability  = ability
      @strategy = options[:strategy] || Permits::Ability.strategy || :default      
      @user_permissions = ::PermissionsLoader.load_user_permissions options[:user_permissions_file]
      @role_permissions = ::PermissionsLoader.load_permits options[:permits_file]
    end

    def permit?(user, options = {})
      if options == :in_role 
        return true if !role_match? user 
      end
      false
    end

    def can(action, subject, conditions = nil, &block)
      rules << rule_class.new(true, action, subject, conditions, block)
    end
        
    def cannot(action, subject, conditions = nil, &block)
      rules << rule_class.new(false, action, subject, conditions, block)
    end
    
    def owns(user, clazz, ownership_relation = :user_id, user_id_attribute = :id, strategy_used = nil)
      begin   
        strategy_used = strategy_used || self.strategy
        user_id = user.send :"#{user_id_attribute}"              
      rescue
        raise ArgumentError, "ERROR (owns) - The user of class #{user.class} does not respond to ##{user_id_attribute}"
      end        
      # puts "can #{clazz} manage ownership: #{ownership_relation.inspect} => #{user_id.inspect} ???" 
      # puts "Using strategy: #{strategy_used}"
      begin
        case strategy_used
        when :string
          can :manage, clazz, ownership_relation => user_id.to_s
        when :default
          can :manage, clazz, ownership_relation => user_id
        else
          raise "Trying to use unknown ownership strategy: #{strategy}"
        end
      rescue Exception => e
        puts e.inspect
      end
    end 

    protected  

    # CanCan 1.5 compatibility
    def rule_class
      return CanCan::Rule if defined? CanCan::Rule
      CanCan::CanDefinition
    end
    
    include Permit::Util

    def localhost_manager?
      Permits::Configuration.localhost_manager
    end

    def role_match? user
      user.has_role? permit_name(self.class)
    end
      
    def rules
      return rules_1_5 if rules_1_5
      return rules_1_4 if rules_1_4
      raise "CanCan ability.rules could not be found. Possibly due to CanCan API change since 1.5"
    end    
    
    def rules_1_5
      ability.send :rules
    end

    def rules_1_4
      ability.send :can_definitions
    end

  end
end
