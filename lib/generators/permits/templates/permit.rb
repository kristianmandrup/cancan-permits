class <%= permit_name.to_s.camelize %>Permit < Permit::Base
  def initialize(ability)
    super
  end

  def permit?(user, request=nil) 
    super
    <%= permit_logic %>    
    licenses :user_admin, :blogging
  end  
end
