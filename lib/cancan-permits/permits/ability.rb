module Permits
  class Ability
    include CanCan::Ability

    # set up each Permit instance to share this same Ability 
    # so that the can and cannot operations work on the same permission collection!
    def self.permits ability, options = {}
      special_permits = []
      special_permits << [:system, :any].map{|role| make_permit(role, ability, options)}
      # puts "Available roles: #{Permits::Roles.available}"
      role_permits = []
      role_permits = Permits::Roles.available.inject([]) do |permits, role|
        permit = make_permit(role, ability, options)
        # puts "made permit: #{permit}"
        permits << permit if permit
      end
      # puts "role_permits: #{role_permits.inspect}"      
      (special_permits + role_permits).flatten.compact
    end

    def initialize user, options = {}
      # put ability logic here!
      user ||= Guest.new   

      all_permits = Permits::Ability.permits(self, options)
      # puts "Trying permits: #{all_permits.inspect}"
      all_permits.each do |permit|
        # get role name of permit 
        permit_role = permit.class.demodulize.gsub(/Permit$/, '').underscore.to_sym

        # puts "Permit role: #{permit_role.inspect}"
        if permit_role == :system
          # always execute system permit
          result = permit.permit?(user, options)
          break if result == :break
        else
          # only execute the permit if the user has the role of the permit or is for any role
          # puts "does user have_role? #{user.has_role?(permit_role)}, #{user.inspect}"
          if user.has_role?(permit_role) || permit_role == :any
            # puts "user: #{user} of #{permit_role} has permit?"
            # puts "permit: #{permit.inspect}"
            permit.permit?(user, options) 
            # else
            # puts "Permit #{permit} not used for role #{permit_role}"
          end
        end
      end
    end      
    
    protected
    
    def self.make_permit role, ability, options = {}
      begin            
        clazz_name = "#{role.to_s.camelize}Permit"
        # puts "Attempting to load #{clazz_name} permition class"
        permit_clazz = clazz_name.constantize
        permit_clazz.new(ability, options) if permit_clazz && permit_clazz.kind_of?(Class)
      rescue
        # puts "permit class not found: #{clazz_name}"
        nil
      end
    end          
  end
end      
