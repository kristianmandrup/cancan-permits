module Permit
  class Base 
    attr_reader :ability

    def licenses *names
      names.to_strings.each do |name|         
        begin
          module_name = "#{name.camelize}License"
          clazz = module_name.constantize
          clazz.new(self).enforce!
        rescue
          # puts "License #{module_name} not found"
        end
      end
    end
       
    def initialize(ability)
      @ability = ability
    end

    def permit?(user, request=nil) 
      false
    end

    def can(action, subject, conditions = nil, &block)
      can_definitions << CanCan::CanDefinition.new(true, action, subject, conditions, block)
    end
        
    def cannot(action, subject, conditions = nil, &block)
      can_definitions << CanCan::CanDefinition.new(false, action, subject, conditions, block)
    end
    
    def owns(user, clazz, ownership_relation = :user_id, user_id_attribute = :id)
      begin
        user_id = user.send :"#{user_id_attribute}"              
      rescue
        raise ArgumentError, "ERROR (owns) - The user of class #{user.class} does not respond to ##{user_id_attribute}"
      end
        can :manage, clazz, ownership_relation => user_id
    end 

    protected

    def localhost_manager?
      Permits::Configuration.localhost_manager
    end

    def role_match? user
      user.has_role? self.class.last_name.gsub(/Permit$/, '').downcase.to_sym
    end
      
    def can_definitions
      ability.send :can_definitions
    end    
  end
end