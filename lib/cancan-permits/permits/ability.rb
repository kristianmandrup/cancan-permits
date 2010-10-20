require 'cancan-permits/permit/util'

module Permits
  class Ability
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
      role_permits = Permits::Roles.available.inject([]) do |permits, role|
        permit = make_permit(role, ability, options)
        permits << permit if permit
      end
      (special_permits + role_permits).flatten.compact
    end

    def initialize user, options = {}
      # put ability logic here!
      user ||= Guest.create
      all_permits = Permits::Ability.permits(self, options)
      all_permits.each do |permit|
        # get role name of permit 
        permit_role = permit_name(permit.class)
        if permit_role == :system
          # always execute system permit
          result = permit.permit?(user, options)
          break if result == :break
        else
          # only execute the permit if the user has the role of the permit or is for any role
          if user.has_role?(permit_role) || permit_role == :any
            permit.permit?(user, options) 
          end
        end
      end
    end      
    
    protected

    include Permit::Util
    
    def self.make_permit role, ability, options = {}
      begin            
        clazz_name = "#{role.to_s.camelize}Permit"
        permit_clazz = clazz_name.constantize
        permit_clazz.new(ability, options) if permit_clazz && permit_clazz.kind_of?(Class)
      rescue
        raise "Permit #{clazz_name} not found"
      end
    end          
  end
end      
