require 'rails-app-spec'

module RSpec::RubyContentMatchers 
  module LicenseFile  
    class HaveLicenseFile
      include ::Rails3::Assist::Artifact::Directory
      
      attr_reader :name
  
      def initialize name
        @name = name
      end

      def license_file name
        File.join(permit_dir, "#{name}.rb")
      end

      def matches? obj, &block
        found = File.file? license_file(name)
        yield if block && found
        found
      end  
    end

    def have_license_file name
      HaveLicenseFile.new name
    end
  end
end
