module Permit               
  module RoleMatcher
    def role_match? user
      user.has_role? permit_name(self.class)
    end

    def role_group_match? user, group_name = nil
      puts "role_group_match #{user}..."
      user.is_in_group? permit_name(self.class)
    end
  end
end
