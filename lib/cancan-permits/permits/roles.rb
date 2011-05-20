# if using cancan-permits standalone, you can do the following
#
# Permits::Roles.role_groups = [:bloggers, :admins]
# 
# Otherwise set the available role groups up either on the User class or in Cream using the Cream#config method
#
module Permits::Roles
  # class level accessors
  mattr_accessor :role_groups, :roles
  
  def self.available_role_groups
    if defined? ::Cream
      Cream::Role.available_role_groups
    elsif defined? ::User
      User.valid_role_groups
    else
      role_groups || []
    end
  end
  
  def self.available_roles
    if defined? ::Cream
      Cream::Role.available
    elsif defined? ::User
      User.roles
    else
      roles || [:admin, :guest]
    end
  end
end

