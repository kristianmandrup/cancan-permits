require 'rails-app-spec'

module RSpec::RailsApp::File
  module Matchers    
    class HaveLicenseFile
      include ::Rails3::Assist::Artifact
      include ::Rails3::Assist::File

      attr_reader :name
    
      def initialize name
        @name = name
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