require 'cancan-permits/permit/util'
require_all File.dirname(__FILE__) + '/builder'

module Permits
  class Ability    
    include CanCan::Ability

    attr_reader :options, :user

    # put ability logic here! 
    # Equivalent to a CanCan Ability#initialize call 
    # which executes all the permission logic
    def initialize user, options = {}
      @user = user
      @user ||= Guest.create      
      @options = options

      # run permit executors
      permits_for(user).each do |permit|
        # execute the permit and break only if the execution returns the special :break symbol
        break if permit.execute(user, options) == :break
      end
    end      
    
    protected                                                                  

    include Permit::Util

    # by default, only execute permits for which the user 
    # has a role or a role group
    # also execute any permit marked as special
    def permits_for user
      special_permits + role_permits_for(user) + role_group_permits_for(user)
    end

    def special_permits
      Permits::Configuration.special_permits
    end
    
    def role_group_permits_for user
      permit_builder.build_role_group_permits_for role_groups_of(user)
    end
    
    def role_permits_for user
      permit_builder.build_role_permits_for roles_of(user)
    end

    # return list of symbols for roles the user has
    def roles_of user
      user.roles_list
    end

    # return list of symbols for role groups the user belongs to
    def role_groups_of user
      user.role_groups_list
    end

    def permit_builder
      @permit_builder ||= Permit::Builder.new self
    end    
  end
end      
