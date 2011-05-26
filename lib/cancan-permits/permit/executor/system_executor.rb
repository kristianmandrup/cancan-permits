module Permit
  class SystemExecutor < Executor 
    # always execute system permit
    def execute!
      permit?(user, options)
    end
  end
end

