module Permit
  class BaseExecutor < Executor
    # execute the permit
    def execute!
      role_execution
      role_group_execution
    end

    # only execute the permit if the user has the role of the permit or is for any role      
    def role_execution
      permit?(user, options) if permit_for_user_role?
    end

    def permit_for_user_role? 
      user.has_role?(role) || role == :any
    end

    def role_group_execution
      # could also use #user.is_member_of?
      permit?(user, options) if permit_for_user_group?
    end
    
    def permit_for_user_group? 
      user.is_in_group?(role)
    end    
    
    protected
    
    def role
      permit.role
    end
  end
end