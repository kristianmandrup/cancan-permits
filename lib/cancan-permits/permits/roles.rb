module Permits::Roles
  def self.available
    if Module.const_defined? :User
      User.ROLES if User.respond_to? :ROLES
    else
      [:guest, :admin]
    end
  end
end
