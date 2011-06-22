class BloggersPermit < RoleGroupPermit::Base
  def initialize(ability, options = {})
    super
  end

  def permit?(user, options = {}) 
    super
    return if !role_match? user
  end 
end
