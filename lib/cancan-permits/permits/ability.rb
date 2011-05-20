require 'cancan-permits/permit/util'

module Permits
  class Ability
    class NoAvailableRoles < StandardError; end
    
    include CanCan::Ability

     class << self
       attr_accessor :orm, :strategy
       
       def orm= orm
         @orm = orm 
         case orm
         when :active_record, :generic
           @strategy = :default
         else
           @strategy = :string
         end
       end
     end

    # set up each Permit instance to share this same Ability 
    # so that the can and cannot operations work on the same permission collection!
    def self.permits ability, options = {}
      special_permits = []
      special_permits << [:system, :any].map{|role| make_permit(role, ability, options)}
      
      raise NoAvailableRoles, "Permits::Roles method #available returns no roles" if !available_roles || available_roles.empty?

      role_permits = (available_roles + [:bloggers]).inject([]) do |permits, role|
        permit = make_permit(role, ability, options)
        permits << permit if permit
      end
      
      # puts "Role permits: #{role_permits}"      
      all_permits = (special_permits + role_permits).flatten.compact
      # puts "All permits: #{all_permits}"
      # all_permits      
    end

    def self.available_roles
      Permits::Roles.available
    end

    def initialize user, options = {}
      # put ability logic here!
      user ||= Guest.create
      all_permits = Permits::Ability.permits(self, options)
      all_permits.each do |permit|
        # get role name of permit 
        permit_role = permit_name(permit.class)
        puts "permit_role: #{permit_role}"
        if permit_role == :system
          # always execute system permit
          result = permit.permit?(user, options)
          break if result == :break
        else
          # only execute the permit if the user has the role of the permit or is for any role
          if user.has_role?(permit_role) || permit_role == :any
            permit.permit?(user, options) 
          end
          if permit_role == :bloggers && user.is_in_group?(:bloggers)
            permit.permit?(user, options)
          end
        end
      end
    end      
    
    protected

    include Permit::Util

    def self.get_permit role
      begin            
        clazz_name = "#{role.to_s.camelize}Permit"
        clazz_name.constantize
      rescue
        raise "Permit #{clazz_name} not loaded and thus not defined"
      end
    end
    
    def self.make_permit role, ability, options = {}
      begin            
        permit_clazz = get_permit role
        permit_clazz.new(ability, options) if permit_clazz && permit_clazz.kind_of?(Class)
      rescue RuntimeError => e
        raise "Error instantiating Permit instance for #{permit_clazz}, cause #{e}"
      end
    end          
  end
end      
