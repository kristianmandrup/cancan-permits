module Permit
  module Loaders
    def load_rules user
      load_role_rules
      load_user_rules user
      load_categories
    end

    def load_role_rules
      return if !role_permissions || role_permissions.permissions.empty?
      name ||= self.class.to_s.gsub(/Permit$/, "").underscore.to_s #ym
        
      return if role_permissions.permissions[name].nil?

      role_permissions.permissions[name].can_eval do |permission_statement|
        instance_eval permission_statement
      end 
      role_permissions.permissions[name].cannot_eval do |permission_statement|
        instance_eval permission_statement
      end
    end

    def load_categories
      raise '#load_categories needs to be implemented'

      return if !categories

      # retrieve from Rails cache
    end

    def load_user_rules user 
      return if !user_permissions || user_permissions.permissions.empty?
      raise "#load_user_rules expects the user to have an email property: #{user.inspect}" if !user || !user.respond_to?(:email) 

      id = user.email
      return nil if id.strip.empty? || user_permissions.permissions[id].nil?

      user_permissions.permissions[id].can_eval do |permission_statement|
        instance_eval permission_statement
      end 
      user_permissions.permissions[id].cannot_eval do |permission_statement|
        instance_eval permission_statement
      end 
    end
  end
end