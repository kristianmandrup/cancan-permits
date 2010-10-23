require 'spec_helper' 
require 'rails' 
require 'simply_stored/couch'

CouchPotato::Config.database_name = "http://localhost:5984/cancan-permits"    

Permits::Ability.orm = :simply_stored

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
      User.create(next_id, :guest, 'Guest')
    end
  end
end


class User
  include SimplyStored::Couch
  
  property :role, :type => String
  property :name, :type => String  

  def self.roles
    [:guest, :admin, :editor]
  end    
  
  def has_role? role
    self.role.to_sym == role.to_sym
  end     
end

                 


