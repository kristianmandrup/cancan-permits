module AuthAssistant
  class Ability
    include CanCan::Ability

    # set up each RolePermit instance to share this same Ability 
    # so that the can and cannot operations work on the same permission collection!
    def self.role_permits ability
      @role_permits = AuthAssistant::Roles.available.inject([]) do |permits, role|
        permits << "RolePermit::#{role.to_s.camelize}".constantize.new(ability)
      end
    end

    def initialize(user, request=nil)
      # put ability logic here!
      user ||= Guest.new   
      Ability.role_permits(self).each{|role_permit| role_permit.permit?(user, request) }
    end      
  end
end      
