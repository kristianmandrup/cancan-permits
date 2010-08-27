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
        g.should have_permits :guest, :admin
      end
    end
  end    
end
