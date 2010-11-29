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

    def load_enforcements name
      return if !licenses || licenses.empty?      
      
      licenses[name].can_statement do |permission_statement|
        instance_eval permission_statement
      end

      licenses[name].cannot_statement do |permission_statement|
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