require 'sugar-high/array'
require_all File.dirname(__FILE__)

module Permit
  class Base           
    attr_reader :ability, :options
    # strategy is used to control the owns strategy (see rules.rb)
    attr_reader :strategy 

    # creates the permit
    def initialize ability, options = {}
      @ability  = ability
      @options  = options
    end
       
    # executes the permit
    def execute user, options
      executor(user, options).execute!
    end

    # Alternatively you can use 
    #
    #   return if !super user, :in_role
    #
    # in order to exit if the user doesn't have a role that matches the Permit.
    #
    def permit?(user, options = {})
      :break if !user_role_match? user, options
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
    
    protected  

    def permits_loader
      Permits::Loader::Permissions
    end

    def strategy
      @strategy ||= options[:strategy] || Permits::Ability.strategy || :default
    end

    def user_role_match?
      (role_match?(user) || role_group_match?(user)) && options == :in_role
    end

    # return the executor used to execute the permit
    def executor 
      @executor ||= Permit::Executor.new self
    end
    
    include Permit::Util
    include Permit::RoleMatcher
    include Permit::CanCanCompatibility
  end
end
