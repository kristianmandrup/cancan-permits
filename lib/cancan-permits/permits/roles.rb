module Permits::Roles
  def self.available
    if defined? ::Cream
      Cream.available_roles
    elsif defined? ::User
      User.roles
    else
      [:admin, :guest]
    end
  end
end
