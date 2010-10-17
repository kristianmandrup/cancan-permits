require 'spec_helper' 
require 'generator-spec'

require_generator :permits

RSpec::Generator.configure do |config|
  config.debug = true
  config.remove_temp_dir = true #false
  config.default_rails_root(__FILE__) 
  config.lib = File.dirname(__FILE__) + '/../lib'
  config.logger = :stdout  # :file
end


describe 'Permits generator' do   
  use_helpers :controller, :special, :file
    
  setup_generator :permits do
    tests PermitsGenerator
  end

  describe 'result of running generator with default profile' do
    before :each do
      @generator = with_generator do |g|    
        arguments = "--orm mongoid".args
        g.run_generator arguments
      end
    end
    
    describe 'result of running Permits generator' do
      it "should create Admin permit" do
        @generator.should generate_permit :admin
      end    
    
      it "should generate a permits initializer file with orm set to mongoid" do      
        File.read(initializer_file(:permits)).should match /Permits::Application.orm = mongoid/
      end      
    end
  end

  # TODO

  # describe 'result of running generator with option to create permit for each registered role' do
  #   context "Registered roles :guest, :admin"
  #     before :each do
  #       with_generator do |g|    
  #         g.run_generator "--roles admin editor"
  #       end
  #     end
  # 
  #     it "should have created Guest and Admin permits" do
  #       # Find at: 'app/permits/admin_permit.rb'
  #       g.should have_permit_files :guest, :admin
  # 
  #       # g.should have_permit_file :guest do |guest_permit|
  #       #   guest_permit.should have_licenses :user_admin, :blogging 
  #       # end
  #       # 
  #       # g.should have_license_file :licenses do |license_file|      
  #       #   license_file.should have_module :license do |license_module|
  #       #     license_module.should have_license_classes :user_admin, :blogging, :superclass => :base
  #       #   end
  #       # end
  #     end
  #   end #ctx
  # end    
end
