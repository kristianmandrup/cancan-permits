module Permit               
  module CanCanCompatibility
    def rules
      return rules_1_5 if rules_1_5
      return rules_1_4 if rules_1_4
      raise "CanCan ability.rules could not be found. Possibly due to CanCan API change since 1.5"
    end    

    def rules_1_5
      ability.send :rules
    end

    def rules_1_4
      ability.send :can_definitions
    end
  end
end