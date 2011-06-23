module Permit
  module Executor
    class Abstract
      attr_accessor :permit, :user_account, :options

      def initialize permit, user_account, options = {}
        @permit, @user_account, @options = [permit, user_account, options]
      end

      def permit?(user_account, options)
        permit.permit?(user_account, options) if permit
      end

      def execute!
        raise "Must be implemented by subclass"
      end
    end
  end
end

