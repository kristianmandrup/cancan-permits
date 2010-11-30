require 'rspec/core'
require 'cancan-permits' 

DIR = File.dirname(__FILE__) 

describe 'Load Permits rules' do
  before :each do
    @permission_file = File.join(DIR, 'config', 'permits.yml')
  end

  it "should load a licenses permission file" do
    loader = PermissionsLoader.new @permissions_file
    # puts "loaded permissions #{loader.permissions}"
    loader.permissions.should_not be_empty    
  end 
  
  it "should be able to instantiate a base license with permission file" do
    Permit::Base.new 'x', @permissions_file
  end   
  
  it "should be able to instantiate a base permit without permission file" do
    Permit::Base.new 'x'
  end     
end




