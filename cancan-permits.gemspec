# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{cancan-permits}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Kristian Mandrup"]
  s.date = %q{2010-09-17}
  s.description = %q{Role specific Permits for use with CanCan permission system}
  s.email = %q{kmandrup@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.markdown"
  ]
  s.files = [
    ".document",
     ".gitignore",
     ".rspec",
     "LICENSE",
     "README.markdown",
     "Rakefile",
     "VERSION",
     "lib/cancan-permits.rb",
     "lib/cancan-permits/namespaces.rb",
     "lib/cancan-permits/permit/base_permit.rb",
     "lib/cancan-permits/permits/abiity.rb",
     "lib/cancan-permits/permits/configuration.rb",
     "lib/cancan-permits/permits/roles.rb",
     "lib/cancan-permits/rspec/config.rb",
     "lib/cancan-permits/rspec/matchers/have_permits.rb",
     "lib/generators/permits/permits_generator.rb",
     "lib/generators/permits/templates/permit.rb",
     "spec/cancan-permits/fixtures/ability.rb",
     "spec/cancan-permits/fixtures/permits/admin_permit.rb",
     "spec/cancan-permits/fixtures/permits/editor_permit.rb",
     "spec/cancan-permits/fixtures/permits/guest_permit.rb",
     "spec/cancan-permits/permits/fixtures/models.rb",
     "spec/cancan-permits/permits/owner_permits_spec.rb",
     "spec/cancan-permits/permits/permits_spec.rb",
     "spec/generators/permit_generator_spec.rb",
     "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/kristianmandrup/cancan-permits}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Permits for use with CanCan}
  s.test_files = [
    "spec/cancan-permits/fixtures/ability.rb",
     "spec/cancan-permits/fixtures/permits/admin_permit.rb",
     "spec/cancan-permits/fixtures/permits/editor_permit.rb",
     "spec/cancan-permits/fixtures/permits/guest_permit.rb",
     "spec/cancan-permits/permits/fixtures/models.rb",
     "spec/cancan-permits/permits/owner_permits_spec.rb",
     "spec/cancan-permits/permits/permits_spec.rb",
     "spec/generators/permit_generator_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, ["~> 2.0.0"])
      s.add_runtime_dependency(%q<cancan>, ["~> 1.3"])
      s.add_runtime_dependency(%q<require_all>, ["~> 1.1"])
      s.add_runtime_dependency(%q<sugar-high>, ["~> 0.1"])
    else
      s.add_dependency(%q<rspec>, ["~> 2.0.0"])
      s.add_dependency(%q<cancan>, ["~> 1.3"])
      s.add_dependency(%q<require_all>, ["~> 1.1"])
      s.add_dependency(%q<sugar-high>, ["~> 0.1"])
    end
  else
    s.add_dependency(%q<rspec>, ["~> 2.0.0"])
    s.add_dependency(%q<cancan>, ["~> 1.3"])
    s.add_dependency(%q<require_all>, ["~> 1.1"])
    s.add_dependency(%q<sugar-high>, ["~> 0.1"])
  end
end
