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
  
  def has_role? role
    self.role.to_sym == role.to_sym
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




