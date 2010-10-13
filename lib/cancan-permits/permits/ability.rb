module Permits
  class Ability
    include CanCan::Ability

    # set up each Permit instance to share this same Ability 
    # so that the can and cannot operations work on the same permission collection!
    def self.permits ability
      special_permits = []
      special_permits << [:system, :any].map{|role| make_permit(role, ability)}
      role_permits = Permits::Roles.available.inject([]) do |permits, role|
        permit = make_permit(role, ability)
        permits << permit if permit
      end
      (special_permits + role_permits).flatten.compact
    end

    def initialize(user, request=nil)
      # put ability logic here!
      user ||= Guest.new   
                  
      Permits::Ability.permits(self).each do |permit|
        # get role name of permit 
        permit_role = permit.class.demodulize.gsub(/Permit$/, '').underscore.to_sym
        
        if permit_role == :system
          # always execute system permit
          result = permit.permit?(user, request)
          break if result == :break
        else
          # only execute the permit if the user has the role of the permit or is for any role
          if user.has_role?(permit_role) || permit_role == :any
            # puts "user: #{user} of #{permit_role} has permit?"
            permit.permit?(user, request) 
          # else
            # puts "Permit #{permit} not used for role #{permit_role}"
          end
        end
      end
    end      
    
    protected
    
    def self.make_permit role, ability
      begin            
        clazz_name = "#{role.to_s.camelize}Permit"
        permit_clazz = clazz_name.constantize
        permit_clazz.new(ability) if permit_clazz && permit_clazz.kind_of?(Class)
      rescue
        # puts "permit class not found: #{clazz_name}"
        nil
      end
    end          
  end
end      
