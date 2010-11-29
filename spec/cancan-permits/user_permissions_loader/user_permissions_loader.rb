require 'rspec/core'
require 'cancan-permits' 

DIR = File.dirname(__FILE__) 

describe 'User Permissions Loader' do
  before :each do
    @permissions_file = File.join(DIR, 'user_permissions.yml')
  end

  it "should load a user permissions file" do
    loader = PermissionsLoader.new @permissions_file
    # puts "loaded permissions #{loader.permissions}"
    loader.permissions.should_not be_empty    
  end    
  
  it "should be able to instantiate a base permit with permission file" do
    Permit::Base.new 'x', :permissions_file => @permissions_file
  end   

  it "should be able to instantiate a base permit without permission file" do
    Permit::Base.new 'x'
  end     
end




