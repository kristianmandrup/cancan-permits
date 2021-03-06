require 'sugar-high/array'

# The permit base class for both Role Permits and Role Group Permits
# Should contain all common logic
module Permit
  class Base           
    attr_reader :ability, :options, :type
    # strategy is used to control the owns strategy (see rules.rb)
    attr_reader :strategy 

    # creates the permit
    def initialize ability, options = {}
      @ability  = ability
      @options  = options
    end
       
    # executes the permit
    def execute user_account, options
      executor(user_account, options).execute!
    end

    def rules
      ability.send :rules
    end

    # In a specific Role based Permit you can use 
    #   def permit? user, options = {}
    #     return if !super(user, :in_role)
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
      false
    end

    # where and how is this used???
    def licenses *names
      names.to_strings.each do |name|         
        begin
          module_name = "#{name.camelize}License"
          clazz = module_name.constantize
        rescue
          raise "License #{module_name} is not defined"
        end

        begin
          clazz.new(self).enforce!
        rescue
          raise "License #{clazz} could not be enforced using #{self.inspect}"
        end
      end
    end

    include Permit::Rules
    include Permit::Loaders

    def user_permissions
      @user_permissions ||= permits_loader.load_user_permissions options[:user_permissions_file]
    end

    def role_permissions
      @role_permissions ||= permits_loader.load_permits options[:permits_file]
    end
   
    def groups_permissions
      @groups_permissions ||= permits_loader.load_groups_permits options[:groups_permits_file]
    end

    protected  

    def permits_loader
      Permits::Loader::Permissions
    end

    def strategy
      @strategy ||= options[:strategy] || Permits::Ability.strategy || :default
    end

    include Permit::RoleMatcher

    def any_role_match? user_account
      role_match?(user_account) || role_group_match?(user_account)
    end

    # return the executor used to execute the permit
    def executor(user_account, options = {}) 
      @executor ||= case self.class.name
      when /System/
        then Permit::Executor::System.new self, user_account, options
      else  
        Permit::Executor::Base.new self, user_account, options
      end
    end
    
    include Permit::Util
    include Permit::CanCanCompatibility
  end
end
