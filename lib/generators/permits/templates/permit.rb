module Permit  
  class <%= permit_name %> < Base
    def initialize(ability)
      super
    end

    def permit?(user, request=nil) 
      super
      return if !role_match? user

      # can :create, Comment            
      # owns(user, Comment)
    end  
  end
end