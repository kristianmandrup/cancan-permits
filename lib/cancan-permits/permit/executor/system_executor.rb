module Permit
  class SystemExecutor 
    # always execute system permit
    def execute!
      permit?(user, options)
    end
  end
end

