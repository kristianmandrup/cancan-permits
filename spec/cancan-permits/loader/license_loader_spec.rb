require 'rspec/core'
require 'cancan-permits' 

DIR = File.dirname(__FILE__) 

describe 'Load License rules' do
  before :each do
    @permissions_file = File.join(DIR, 'config', 'licenses.yml')
  end

  it "should load a licenses permission file" do
    loader = PermissionsLoader.new @permissions_file
    # puts "loaded permissions #{loader.permissions}"
    loader.permissions.should_not be_empty    
  end 
  
  it "should be able to instantiate a base license with permission file" do
    License::Base.new 'x', @permissions_file
  end   
  
  it "should be able to instantiate a base permit without permission file" do
    License::Base.new 'x'
  end     
end




