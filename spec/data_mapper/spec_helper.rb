require 'rspec/core' 

require 'dm-core'
require 'dm-types'
require 'dm-migrations'

require 'cancan/matchers'
require 'cancan-permits'
require 'cancan-permits/rspec'

# gem install dm-core dm-sqlite-adapter 
# gem install dm-types dm-validations dm-timestamps dm-aggregates dm-adjust dm-is-list dm-is-tree dm-is-versioned dm-is-nested_set 
# gem install rails_datamapper dm-migrations dm-observer

DataMapper::Logger.new($stdout, :debug)                 
DataMapper.setup(:default, 'sqlite::memory:')

RSpec.configure do |config|
  config.mock_with :mocha
end


require_all File.dirname(__FILE__) + '/../generic/fixtures/permits'
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


