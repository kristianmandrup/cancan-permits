require 'sugar-high/class_ext'
module Permit
  class Builder
    include ClassExt
    class NoAvailableRoles < StandardError; end
    
    attr_accessor :ability, :account

    def initialize ability
      @ability = ability
      puts "Ability: #{ability.inspect}"
      @account = ability.user_account
      puts "Account: #{account.inspect}"
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
      get_permit role
    end    
    
    def get_permit role
      begin            
        find_first_class account_role_permit_class(role), role_permit_class(role)
      rescue
        raise "Permit for role #{role} could not be loaded. Define either class: #{account_role_permit_class(role)} or #{role_permit_class(role)}"
      end
    end

    # this is used to namespace role permits for a specific type of user account
    # this allows role permits to be defined differently for each user account (and hence sub application) if need be
    # otherwise it will fall back to the generic role permit (the one which is not wrapped in a user account namespace)
    def account_role_permit_class role
      [account_permit_ns , role_permit_class(role)].join('::')
    end

    def account_permit_ns
      "#{account.class}Permits"
    end

    def role_permit_class role
      "#{role.to_s.camelize}Permit"
    end
    
    def special_permits
      [:system, :any]
    end    
  end
end

