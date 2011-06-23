require 'yaml'

module License
  class Base
    include License::Rules
    include License::Loader

    attr_reader :permit, :licenses
    
    def initialize permit, licenses_file = nil
      @permit   = permit
      @licenses = permits_loader.load_licenses licenses_file
    end

    def enforce!
      raise "enforce! must be implemented by subclass of License::Base"
    end
    
    protected
    
    def permits_loader
      Permits::Loader::Permissions
    end
  end
end
