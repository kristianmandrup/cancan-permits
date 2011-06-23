require 'cancan-permits/permit/util'
require_all File.dirname(__FILE__) + '/builder'

module Permits
  class Ability    
    include CanCan::Ability

    attr_reader :options, :user_account

    # put ability logic here! 
    # Equivalent to a CanCan Ability#initialize call 
    # which executes all the permission logic
    def initialize user_account, options = {}
      @user_account = user_account
      @user_account ||= Guest.create      
      @options = options

      # run permit executors
      permits.each do |permit|
      #  # execute the permit and break only if the execution returns the special :break symbol
        puts "Permit is: #{permit}"
        break if permit.execute(user_account, options) == :break
      end
    end      
    
    include Permit::Util

    # by default, only execute permits for which the user 
    # has a role or a role group
    # also execute any permit marked as special
    def permits
      special_permits + role_group_permits + role_permits
    end

    def special_permits
      permit_builder.build_special_permits
    end
    
    def role_group_permits
      permit_builder.build_role_group_permits_for role_groups
    end
    
    def role_permits
      permit_builder.build_role_permits_for roles
    end

    # return list of symbols for roles the user has
    def roles
      user_account.roles_list
    end

    # return list of symbols for role groups the user belongs to
    def role_groups
      groups = []
      user_account_class.role_groups.map{|k,v| groups << k if user_account.has_any_role?(v)}
      groups
    end

    def user_account_class
      user_account.class
    end

    def permit_builder
      @permit_builder ||= Permit::Builder.new self
    end    
  end
end      
