require 'spec_helper' 
require 'mongo_mapper'

Permits::Ability.orm = :mongo_mapper

MongoMapper.database = 'cancan-permits_mongo_mapper'

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
  include MongoMapper::Document
  
  key :role, String
  key :name, String  

  def self.roles
    [:guest, :admin, :editor]
  end    
  
  def has_role? role
    self.role.to_sym == role.to_sym
  end     
end
                
module Database
  def self.teardown
    # MongoMapper.database.collections.each {|collection| collection.drop }    
    MongoMapper.database.collections.each do |coll|
      coll.drop unless coll.name =~ /(.*\.)?system\..*/
    end    
  end
end


RSpec.configure do |config|
  config.mock_with :mocha
  config.before do
    MongoMapper.database.collections.each do |coll|
      coll.drop unless coll.name =~ /(.*\.)?system\..*/
    end    
  end
end




