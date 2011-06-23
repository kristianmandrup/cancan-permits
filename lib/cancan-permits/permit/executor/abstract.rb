module Permit
  module Executor
    class Abstract
      attr_accessor :permit, :user, :options

      def initialize permit, user, options = {}
        @permit, @user, @options = [permit, user, options]
      end

      def permit?(user, options)
        permit.permit?(user, options) if permit
      end

      def execute!
        raise "Must be implemented by subclass"
      end
    end
  end
end

