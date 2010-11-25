require 'rails-app-spec'

module RSpec::RubyContentMatchers 
  module LicenseFile  
    class HaveLicenseFile
      include ::Rails3::Assist::Artifact::Directory
      include ::Rails3::Assist::Directory
      
      attr_reader :name
  
      def initialize name
        @name = name
      end

      def license_file name
        File.join(app_dir, 'licenses', "#{name}_license.rb")
      end

      def matches? obj, &block
        file_name = license_file(name)
        found = File.file? file_name
        yield File.read(file_name) if block && found
        found
      end  
    end

    def have_license_file name
      HaveLicenseFile.new name
    end
  end
end
