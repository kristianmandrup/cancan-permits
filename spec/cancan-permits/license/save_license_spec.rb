require 'rspec/core'
require 'cancan-permits'
require 'rails'

DIR = File.dirname(__FILE__) 

require_all DIR + '/../../../app/models' 

describe 'Save License to yaml' do
  before :each do
    @license = LicenseConfig.new :name => 'blogging'
    @license.can = PermissionSet.new :read => ['Article', 'Post']    
  end

  it "should save license to license.yml file" do
    puts @license
    puts @license.to_yaml    
  end     
end




