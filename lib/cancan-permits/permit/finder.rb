module Permit
  class Finder
    include ClassExt

    attr_reader :account, :role

    def initialize account, role
      @account = account      
      @role = role
    end
    
    def get_permit
      begin            
        find_first_class account_role_permit_class, role_permit_class
      rescue
        raise "Permit for role #{role} could not be loaded. Define either class: #{account_role_permit_class} or #{role_permit_class}"
      end
    end

    # this is used to namespace role permits for a specific type of user account
    # this allows role permits to be defined differently for each user account (and hence sub application) if need be
    # otherwise it will fall back to the generic role permit (the one which is not wrapped in a user account namespace)
    def account_role_permit_class
      [account_permit_ns , role_permit_class].join('::')
    end

    def account_permit_ns
      "#{account.class}Permits"
    end

    def role_permit_class
      "#{role.to_s.camelize}Permit"
    end
  end
end