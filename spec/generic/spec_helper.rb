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
  attr_accessor :id, :role, :name

  def self.roles
    [:guest, :admin, :editor, :super_admin]
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
