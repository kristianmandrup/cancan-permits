require 'rspec'
require 'rspec/autorun' 
require 'cancan/matchers'
require 'cancan-permits'

require_all File.dirname(__FILE__) + 'cancan-permits/fixtures/permits'
require 'cancan-permits/fixtures/ability'

RSpec.configure do |config|
  config.mock_with :mocha
end

module AuthAssistant::Roles
  def self.available
    User.roles
  end
end

class User
  attr_accessor :id, :role, :name

  def self.roles
    [:guest, :admin, :editor]
  end    

  def initialize id, role, name
    self.id = id    
    raise ArgumentError, "Role #{role} is not in list of available roles: #{self.class.roles}" if !self.class.roles.include? role
    self.role = role
    self.name = name
  end
  
  def has_role? role
    self.role == role
  end     
end
