require 'yaml'

module License
  class Base
    attr_reader :permit, :licenses
    
    def initialize permit, licenses_file = nil
      @permit = permit
      @licenses = ::PermissionsLoader.load_licenses licenses_file
    end

    def enforce!
      raise "enforce! must be implemented by subclass of License::Base"
    end

    def load_rules name = nil
      return if !licenses || licenses.permissions.empty?      

      name ||= self.class.to_s.gsub(/License$/, "").underscore
            
      return if licenses.permissions[name].nil?

      licenses.permissions[name].can_eval do |permission_statement|
        instance_eval permission_statement
      end 
      licenses.permissions[name].cannot_eval do |permission_statement|
        instance_eval permission_statement
      end
    end
    
    def can(action, subject, conditions = nil, &block)
      permit.can action, subject, conditions, &block
    end
        
    def cannot(action, subject, conditions = nil, &block)
      permit.cannot action, subject, conditions, &block
    end
    
    def owns(user, clazz, ownership_relation = :user_id, user_id_attribute = :id)
      permit.owns user, clazz, ownership_relation, user_id_attribute
    end
  end
end
