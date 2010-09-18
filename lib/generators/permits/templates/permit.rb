module Permit  
  class <%= permit_name %> < Base
    def initialize(ability)
      super
    end

    def permit?(user, request=nil) 
      super
      <%= permit logic %>
      
      licenses :user_admin, :blogging
    end  
  end
end