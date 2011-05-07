module Permits::Roles
  def self.available
    if defined? ::Cream
      Cream::Role.available
    elsif defined? ::User
      User.roles
    else
      [:admin, :guest]
    end
  end
end
