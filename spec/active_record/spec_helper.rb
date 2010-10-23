require 'spec_helper'

require 'rails'
require 'active_record'
require 'arel'
require 'meta_where'
require 'yaml'
require 'logger'
require 'database_cleaner'

module Rails
  def self.config_root_dir
    File.dirname(__FILE__)
  end
end

Permits::Ability.orm = :active_record

path = File.dirname(__FILE__) + '/db/database.yml'
dbfile = File.open(path)
dbconfig = YAML::load(dbfile)  
ActiveRecord::Base.establish_connection(dbconfig)
ActiveRecord::Base.logger = Logger.new(STDERR)

DatabaseCleaner.strategy = :truncation

# $ rake VERSION=0

def migration_folder(name)
  path = File.dirname(__FILE__) + "/migrations"
  name ? File.join(path name) : path
end

ORM_NAME = 'Active Record'

def migrate(name = nil)                
  mig_folder = migration_folder(name)
  puts "Migrating folder: #{mig_folder}"
  ActiveRecord::Migrator.migrate mig_folder
end

RSpec.configure do |config| 
  config.mock_with :mocha
    
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
    # DatabaseCleaner.clean 
  end

  config.before(:each) do
    DatabaseCleaner.start
    migrate
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end  
end

require_all File.dirname(__FILE__) + '/models/all_models'

module Permits::Roles
  def self.available
    User.roles
  end
end

class User < ActiveRecord::Base  
  has_many :articles
  has_many :comments
  has_many :posts

  def self.roles
    [:guest, :admin, :editor]
  end    
  
  def has_role? role
    self.role.to_sym == role.to_sym
  end
end










