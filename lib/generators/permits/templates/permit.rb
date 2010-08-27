module Permit  
  class <%= permit_name %> < Base
    def initialize(ability)
      super
    end

    def permit?(user, request=nil) 
      super
      <%= permit logic %>
    end  
  end
end