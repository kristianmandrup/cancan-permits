class <%= permit_name.to_s.camelize %>Permit < Permit::Base
  def initialize(ability, options = {})
    super
  end

  def permit?(user, options = {}) 
    super
    <%= permit_logic %>    
    licenses :user_admin, :blogging
  end  
end
