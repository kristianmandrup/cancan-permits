module Permits
  class Ability
    include CanCan::Ability

    # set up each RolePermit instance to share this same Ability 
    # so that the can and cannot operations work on the same permission collection!
    def self.permits ability
      special_permits << [:system, :any].map{|name| make_permit(role, ability)}
      role_permits = Permits::Roles.available.inject([]) do |permits, role|
        permits << make_permit role, ability
      end
      special_permits + role_permits
    end

    def initialize(user, request=nil)
      # put ability logic here!
      user ||= Guest.new   
                  
      Ability.permits(self).each do |permit|
        # get role name of permit 
        permit_role = permit.class.demodulize.to_sym                      
        
        if permit_role == :system
          # always execute system permit
          result = role_permit.permit?(user, request)
          break if result != :continue
        else
          # only execute the permit if the user has the role of the permit or is for any role
          role_permit.permit?(user, request) if user.has_role?(permit_role) || permit_role == :any
        end
      end
    end      
    
    protected
    
    def self.make_permit role, ability
      "Permit::#{role.to_s.camelize}".constantize.new(ability)
    end          
  end
end      
