module Permit
  class Builder
    class NoAvailableRoles < StandardError; end
    
    attr_accessor :permit, :ability, :options

    def initialize permit, ability, options = {}
      @permit, @ability, @options = [permit, ability, options]
    end

    def build!
      raise NoAvailableRoles, "Permits::Roles method #available returns no roles" if !available_roles || available_roles.empty?
      (special_permits + role_permits).flatten.compact      
    end

    protected
    
    def special_permits
      [] << [:system, :any].map{|role| make_permit(role, ability, options)}
    end    

    def role_permits 
      (available_roles + available_role_groups).inject([]) do |permits, role|
        permit = make_permit(role, ability, options)
        permits << permit if permit
      end
    end    
    
    def available_roles
      Permits::Roles.available_roles
    end    

    def available_role_groups
      Permits::Roles.available_role_groups
    end
    
    def make_permit role
      begin            
        permit_clazz(role).new(ability, options)
      rescue RuntimeError => e
        raise "Error instantiating Permit instance for #{permit_clazz}, cause #{e}"
      end
    end                  

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
  end
end

