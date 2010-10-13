require 'rspec/core' 
require 'mongoid'
require 'cancan/matchers'
require 'cancan-permits'
require 'cancan-permits/rspec'

require_all File.dirname(__FILE__) + '/../cancan-permits/fixtures/permits'
require_all File.dirname(__FILE__) + '/models/all_models'

RSpec.configure do |config|
  config.mock_with :mocha
end

module Permits::Roles
  def self.available
    User.roles
  end
end

class User
  include Mongoid::Document
  
  field :role, :type => String
  field :name, :type => String  

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

                 
Mongoid.configure.master = Mongo::Connection.new.db('cancan_permits')

module Database
  def self.teardown     
    Mongoid.database.collections.each do |coll|
      coll.remove
    end
  end
end

Mongoid.database.collections.each do |coll|
  coll.remove
end

RSpec.configure do |config|
  config.mock_with :mocha
  config.before do
    Mongoid.database.collections.each do |coll|
      coll.remove
    end
  end
end




