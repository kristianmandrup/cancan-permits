require 'rspec/core'
require 'cancan/matchers'
require 'cancan-permits'
require 'cancan-permits/rspec'

require_all File.dirname(__FILE__) + '/generic/fixtures/permits'

require_all File.dirname(__FILE__) + '/generic/permits/fixtures'

RSpec.configure do |config|
  config.mock_with :mocha
end

module Permits::Roles
  def self.available
    User.roles
  end
end

class User
  attr_accessor :id, :role, :name

  def self.roles
    [:guest, :admin, :editor]
  end    

  def initialize id, role, name = nil
    self.id = id    
    raise ArgumentError, "Role #{role} is not in list of available roles: #{self.class.roles}" if !self.class.roles.include? role
    self.role = role
    self.name = name || role.to_s
  end
  
  def has_role? role
    self.role == role
  end     
end
