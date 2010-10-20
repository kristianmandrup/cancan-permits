require 'cancan-permits/permit/util'

module Permit
  class Base 
    attr_reader :ability
    attr_reader :strategy # this can be used to customize the strategy used by owns to determine ownership, fx to support alternative ORMs 

    def licenses *names
      names.to_strings.each do |name|         
        begin
          module_name = "#{name.camelize}License"
          clazz = module_name.constantize
          clazz.new(self).enforce!
        rescue
          raise "License #{module_name} not found"
        end
      end
    end
       
    def initialize ability, options = {}
      @ability  = ability
      @strategy = options[:strategy] || Permits::Ability.strategy || :default      
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