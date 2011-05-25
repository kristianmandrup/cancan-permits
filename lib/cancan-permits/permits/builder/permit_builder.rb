module Permit
  class Builder
    class NoAvailableRoles < StandardError; end
    
    attr_accessor :ability

    def initialize ability
      @ability = ability
    end

    def build!
      raise NoAvailableRoles, "Permits::Roles method #available returns no roles" if !available_roles || available_roles.empty?
      (special_permits + role_permits).flatten.compact      
    end

    def build_role_permits_for roles
      roles.inject([]) do |permits, role|
        permits << make_permit(role, :role)
      end.compact
    end

    def build_special_permits
      make_special_permits
    end

    protected

    def options
      ability.options
    end
    
    def make_special_permits
      #special_permits.map{|role| make_permit(role, :special)}
      [ make_permit(:any, :role), make_permit(:system, :system) ]
    end    

    def all_available_roles
      available_roles + available_role_groups
    end
    
    def available_roles
      Permits::Roles.available_roles
    end    

    def available_roles_for user
      user.roles_list
    end    

    def available_role_groups
      Permits::Roles.available_role_groups
    end
    
    def make_permit role, type
      begin            
        permit_clazz(role).new(ability, type, options)
      rescue RuntimeError => e
        raise "Error instantiating Permit instance for #{permit_clazz}, cause #{e}"
      end
    end                  
    
    private

    def permit_clazz role
      get_permit role
    end    
    
    def get_permit role
      begin            
        clazz_name = "#{role.to_s.camelize}Permit"
        clazz_name.constantize
      rescue
        raise "Permit #{clazz_name} not loaded and thus not defined"
      end
    end
    
    def special_permits
      [:system, :any]
    end    
  end
end

