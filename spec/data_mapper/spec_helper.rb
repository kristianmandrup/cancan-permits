require 'spec_helper'

require 'dm-core'
require 'dm-types'
require 'dm-migrations'

DataMapper::Logger.new($stdout, :debug)                 
DataMapper.setup(:default, 'sqlite::memory:')

Permits::Ability.orm = :data_mapper

RSpec.configure do |config|
  config.mock_with :mocha
end

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
  include DataMapper::Resource  

  property :id, Serial  
  property :role, String
  property :name, String 


  def self.roles
    [:guest, :admin, :editor]
  end    
  
  def has_role? role
    self.role.to_sym == role.to_sym
  end
end

DataMapper.finalize
DataMapper.auto_migrate!


