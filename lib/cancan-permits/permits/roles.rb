module Permits::Roles
  def self.available
    if Module.const_defined? :User
      User.roles if User.respond_to? :roles
    else
      [:guest, :admin]
    end
  end
end