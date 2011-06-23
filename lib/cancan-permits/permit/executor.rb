module Permit
  module Executor
    autoload :Abstract,       'cancan-permits/permit/executor/abstract'
    autoload :Base,           'cancan-permits/permit/executor/base'
    autoload :System,         'cancan-permits/permit/executor/system'
  end
end
