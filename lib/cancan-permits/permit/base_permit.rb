require 'cancan-permits/permit/util'
require 'sugar-high/array'

module Permit
  class Base 
    attr_reader :ability
    attr_reader :strategy # this can be used to customize the strategy used by owns to determine ownership, fx to support alternative ORMs 

    attr_reader :user_permissions

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

    def load_enforcements user 
      return if !user_permissions || user_permissions.empty?
      raise "#load_enforcements expects the user to have an email property: #{user.inspect}" if !user || !user.respond_to?(:email) 

      id = user.email
      return nil if id.strip.empty?

      user_permissions[id].can_statement do |permission_statement|
        instance_eval permission_statement
      end

      user_permissions[id].cannot_statement do |permission_statement|
        instance_eval permission_statement
      end
    end
       
    def initialize ability, options = {}
      @ability  = ability
      @strategy = options[:strategy] || Permits::Ability.strategy || :default      
      @user_permissions = ::PermissionsLoader.load_user_permissions options[:permissions_file]
    end

    def permit?(user, options = {}) 
      false
    end

    def can(action, subject, conditions = nil, &block)
      can_definitions << CanCan::CanDefinition.new(true, action, subject, conditions, block)
    end
        
    def cannot(action, subject, conditions = nil, &block)
      can_definitions << CanCan::CanDefinition.new(false, action, subject, conditions, block)
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
    
    include Permit::Util

    def localhost_manager?
      Permits::Configuration.localhost_manager
    end

    def role_match? user
      user.has_role? permit_name(self.class)
    end
      
    def can_definitions
      ability.send :can_definitions
    end    
  end
end