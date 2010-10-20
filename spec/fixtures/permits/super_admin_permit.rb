class SuperAdminPermit < Permit::Base
  def initialize(ability, options = {})
    super
  end

  def permit?(user, options = {})    
    super
    return if !role_match? user
    
    can :manage, :all    
  end  
end