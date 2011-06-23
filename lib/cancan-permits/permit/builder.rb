require 'sugar-high/class_ext'

module Permit
  class Builder
    include ClassExt
    class NoAvailableRoles < StandardError; end
    
    attr_accessor :ability, :account

    def initialize ability
      @ability = ability
      @account = ability.user_account
    end

    def build!
      raise NoAvailableRoles, "Permits::Roles method #available returns no roles" if !available_roles || available_roles.empty?
      (special_permits + role_permits).flatten.compact      
    end

    def build_role_permits_for roles
      roles.inject([]) do |permits, role|
        permits << make_permit(role)
      end.compact
    end

    def build_role_group_permits_for groups
      groups.inject([]) do |permits, role|
        permits << make_permit(role)
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
      special_permits.map{|role| make_permit(role)}
    end    

    def make_permit role
      inspect!(local_variables,binding)
      begin            
        permit_clazz(role).new(ability, options)
      rescue RuntimeError => e
        raise "Error instantiating Permit instance for role #{role}, cause #{e}"
      end
    end                  
    
    private

    def permit_clazz role
      Permit::Finder.new(account, role).get_permit
    end
    
    def special_permits
      [:system, :any]
    end    
  end
end

