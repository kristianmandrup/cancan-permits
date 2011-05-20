module Permit
  class Executor
    attr_accessor :permit, :user, :options

    def initialize permit, user, options = {}
      @permit, @user, @options = [permit, user, options]
    end

    def execute!
      raise "Must be implemented by subclass"
    end
  end
end

