class UserPermission < PermissionHolder
  attr_accessor :email
  
  def name
    self.email
  end
end