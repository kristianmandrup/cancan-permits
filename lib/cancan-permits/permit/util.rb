module Permit               
  module Util
    def permit_name clazz
      @name ||= clazz.demodulize.gsub(/Permit$/, '').underscore.to_sym
    end

    def role
      @role ||= permit_name(self.class)
    end
    
    # CanCan 1.5 compatibility
    def rule_class
      return CanCan::Rule if defined? CanCan::Rule
      CanCan::CanDefinition
    end

    def localhost_manager?
      Permits::Configuration.localhost_manager
    end    
  end
end
