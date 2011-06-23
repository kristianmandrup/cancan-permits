module Permits
  class Configuration
    autoload :Categories,     'cancan-permits/permits/configuration/categories'
    autoload :Permissions,    'cancan-permits/permits/configuration/permissions'    
    
    mattr_accessor :localhost_manager
    mattr_accessor :special_permits
    
    def self.special_permits
      @special_permits ||= Set.new 
      @special_permits = [:system, :any] if @special_permits.empty?
      @special_permits
    end

    def self.special_permits= permits
      @special_permits = permits + default_special_permits
    end
    
    def self.default_special_permits
      [:system, :any]
    end
  end
end