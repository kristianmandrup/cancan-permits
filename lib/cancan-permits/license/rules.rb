module License
  class Rules
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