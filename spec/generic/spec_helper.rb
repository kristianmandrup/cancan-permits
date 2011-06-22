require 'spec_helper'

require_all File.dirname(__FILE__) + '/models/all_models'

RSpec.configure do |config|
  config.mock_with :mocha
end

module Permits::Roles
  def self.available
    User.roles
  end
end

class Guest
  class << self
    attr_accessor :id_counter

    def next_id
      @id_counter += 1      
    end
      
    def create
      User.new next_id, :guest, 'Guest'
    end
  end
end

class User
  extend ClassRoles
  include InstanceRoles
  
  attr_accessor :id, :role, :name

  def initialize id, role, name = nil
    self.id = id    
    raise ArgumentError, "Role #{role} is not in list of available roles: #{self.class.roles}" if !self.class.roles.include? role
    self.role = role
    self.name = name || role.to_s
  end
  
end

class AdminAccount
  extend ClassRoles
  include InstanceRoles

  attr_accessor :user_id, :role

  def initialize user_id, role, name = nil
    self.user_id = user_id    
    raise ArgumentError, "Role #{role} is not in list of available roles: #{self.class.roles}" if !self.class.roles.include? role
    self.role = role
  end

end
