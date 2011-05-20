require 'cancan-permits/permit/util'
require 'sugar-high/array'

module Permit
  class Base 
    attr_reader :ability
    attr_reader :strategy # this can be used to customize the strategy used by owns to determine ownership, fx to support alternative ORMs 

    attr_reader :user_permissions, :role_permissions

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
       
    def initialize ability, options = {}
      @ability  = ability
      @strategy = options[:strategy] || Permits::Ability.strategy || :default      

      @user_permissions = ::PermissionsLoader.load_user_permissions options[:user_permissions_file]
      @role_permissions = ::PermissionsLoader.load_permits options[:permits_file]
      
      configure_executor
    end

    def execute user, options
      executor(user, options).execute!
    end

    # Add role_group_match check?
    def permit?(user, options = {})
      if options == :in_role 
        # not sure what this is!?
        return true if !(role_match?(user) || role_group_match?(user))
      end
      false
    end

    include Permit::Rules
    include Permit::Loaders

    protected  

    def executor 
      @executor ||= Permit::Executor.new self
    end
    
    include Permit::Util
    include Permit::RoleMatcher
    include Permit::CanCanCompatibility
  end
end
