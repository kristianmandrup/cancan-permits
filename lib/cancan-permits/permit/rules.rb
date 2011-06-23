module Permit               
  module Rules
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
  end
end