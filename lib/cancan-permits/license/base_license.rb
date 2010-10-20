module License
  class Base
    attr_reader :permit
    
    def initialize permit
      @permit = permit
    end

    def enforce!
      raise "enforce! must be implemented by subclass of License::Base"
    end
    
    def can(action, subject, conditions = nil, &block)
      permit.can action, subject, conditions, &block
    end
        
    def cannot(action, subject, conditions = nil, &block)
      permit.cannot action, subject, conditions, &block
    end
    
    def owns(user, clazz, ownership_relation = :user_id, user_id_attribute = :id)
      permit.owns user, clazz, ownership_relation, user_id_attribute
    end
  end
end