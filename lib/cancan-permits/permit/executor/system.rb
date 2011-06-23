module Permit
  module Executor 
    class System < Abstract 
      # always execute system permit
      def execute!
        permit?(user_account, options)
      end
    end
  end
end

