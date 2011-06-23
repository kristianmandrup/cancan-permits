module RSpec
  module RubyContentMatchers
    autoload :License,       'cancan-permits/rspec/matchers/have_license'
    autoload :LicenseClass,  'cancan-permits/rspec/matchers/have_license_class'
    autoload :LicenseFile,   'cancan-permits/rspec/matchers/have_license_file'
  end
end