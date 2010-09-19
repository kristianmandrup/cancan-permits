module Cream
  class Ability
    include CanCan::Ability

    # set up each RolePermit instance to share this same Ability 
    # so that the can and cannot operations work on the same permission collection!
    def self.role_permits ability
      @role_permits = Cream::Roles.available.inject([]) do |permits, role|
        begin
          permit_clazz = "#{role.to_s.camelize}Permit".constantize
          permits << permit_clazz.new(ability) if permit_clazz && permit_clazz.kind_of?(Class)
        rescue
          # error
        end
      end
    end

    def initialize(user, request=nil)
      # put ability logic here!
      user ||= Guest.new   
      Ability.role_permits(self).each{|role_permit| role_permit.permit?(user, request) }
    end      
  end
end      
