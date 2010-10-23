require 'spec_helper' 
require 'mongoid'

require_all File.dirname(__FILE__) + '/models/all_models'

Mongoid.configure.master = Mongo::Connection.new.db('cancan_permits')

Permits::Ability.orm = :mongoid

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
                 
module Database
  def self.teardown     
    Mongoid.database.collections.each do |coll|
      coll.remove
    end
  end
end

RSpec.configure do |config|
  config.mock_with :mocha
  config.before do
    Mongoid.database.collections.each do |coll|
      coll.remove
    end
  end
end




