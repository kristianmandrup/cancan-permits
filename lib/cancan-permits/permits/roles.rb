module Permits::Roles
  def self.available
    if Module.const_defined? :User
      [:guest, :admin]
      #User.defined_roles if User.respond_to? :defined_roles
    else
      [:guest, :admin]
    end
  end
end
