require 'sugar-high/array'

module RoleGroupPermit
  class Base < Permit::Base           

    # creates the permit
    def initialize ability, options = {}
      super
    end
       
    # In a specific Role based Permit you can use 
    #   def permit? user, options = {}
    #     return if !super(user, :in_group)
    #     ... permission logic follows
    #
    # This will call the Permit::Base#permit? instance method (the method below)
    # It will only return true if the user matches the role of the Permit class and the
    # options passed in is set to :in_role
    #
    # If these confitions are not met, it will return false and thus the outer permit 
    # will not run the permission logic to follow
    #
    # Normally super for #permit? should not be called except for this case, 
    # or if subclassing another Permit than Permit::Base
    #
    def permit? user_account, options = {}   
      role_group_match?(user_account) && options == :in_group
    end
  end
end
