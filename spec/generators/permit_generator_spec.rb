require 'spec_helper' 
require 'generator-spec'

describe 'Permits generator' do
  GeneratorSpec.with_generator do
    tests PermitsGenerator
  end

  describe 'result of running generator with default profile' do
    before :each do
      GeneratorSpec.with_generator do |g, check|    
        g.run_generator
      end
    end

    it "should create Admin permit" do
      g.should have_permit :admin
    end
  end

  describe 'result of running generator with option to create permit for each registered role' do
    context "Registered roles :guest, :admin"
      before :each do
        GeneratorSpec.with_generator do |g, check|    
          g.run_generator "--roles admin guest"
        end
      end

      it "should have created Guest and Admin permits" do
        # Find at: 'app/permits/admin_permit.rb'
        g.should have_permit_files :guest, :admin

        g.should have_permit_file :guest do |guest_permit|
          guest_permit.should have_licenses :user_admin, :blogging 
        end

        g.should have_license_file :licenses do |license_file|      
          license_file.should have_module :license do |license_module|
            license_module.should have_license_classes :user_admin, :blogging, :superclass => :base
          end
        end
      end
    end
  end    
end
