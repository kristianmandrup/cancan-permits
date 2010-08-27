module RolePermit
  class Admin < Base
    def initialize(ability)
      super
    end

    def permit?(user, request=nil)    
      super
      return if !role_match? user
      
      can :manage, :all    
    end  
  end
end