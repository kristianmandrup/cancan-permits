# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{cancan-permits}
  s.version = "0.3.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Kristian Mandrup"]
  s.date = %q{2010-11-28}
  s.description = %q{Role specific Permits for use with CanCan permission system}
  s.email = %q{kmandrup@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
    "README.markdown"
  ]
  s.files = [
    ".document",
    ".rspec",
    "Changelog.txt",
    "LICENSE",
    "README.markdown",
    "Rakefile",
    "VERSION",
    "cancan-permits.gemspec",
    "development.sqlite3",
    "lib/cancan-permits.rb",
    "lib/cancan-permits/license/base_license.rb",
    "lib/cancan-permits/main.rb",
    "lib/cancan-permits/namespaces.rb",
    "lib/cancan-permits/permit/base_permit.rb",
    "lib/cancan-permits/permit/util.rb",
    "lib/cancan-permits/permits/ability.rb",
    "lib/cancan-permits/permits/configuration.rb",
    "lib/cancan-permits/permits/roles.rb",
    "lib/cancan-permits/rspec.rb",
    "lib/cancan-permits/rspec/config.rb",
    "lib/cancan-permits/rspec/matchers/have_license.rb",
    "lib/cancan-permits/rspec/matchers/have_license_class.rb",
    "lib/cancan-permits/rspec/matchers/have_license_file.rb",
    "lib/generators/cancan/license/license_generator.rb",
    "lib/generators/cancan/license/templates/license.rb",
    "lib/generators/cancan/licenses/licenses_generator.rb",
    "lib/generators/cancan/licenses/templates/base_license.rb",
    "lib/generators/cancan/licenses/templates/blogging_license.rb",
    "lib/generators/cancan/licenses/templates/user_admin_license.rb",
    "lib/generators/cancan/permit/permit_generator.rb",
    "lib/generators/cancan/permit/templates/role_permit.rb",
    "lib/generators/cancan/permits/permits_generator.rb",
    "lib/generators/cancan/permits/templates/permit.rb",
    "spec/active_record/db/database.yml",
    "spec/active_record/migrations/001_create_user.rb",
    "spec/active_record/migrations/002_create_comment.rb",
    "spec/active_record/migrations/003_create_post.rb",
    "spec/active_record/migrations/004_create_article.rb",
    "spec/active_record/models/all_models.rb",
    "spec/active_record/owner_permits_spec.rb",
    "spec/active_record/permits_spec.rb",
    "spec/active_record/spec_helper.rb",
    "spec/data_mapper/models/all_models.rb",
    "spec/data_mapper/owner_permits_spec.rb",
    "spec/data_mapper/permits_spec.rb",
    "spec/data_mapper/spec_helper.rb",
    "spec/fixtures/permits/admin_permit.rb",
    "spec/fixtures/permits/any_permit.rb",
    "spec/fixtures/permits/editor_permit.rb",
    "spec/fixtures/permits/guest_permit.rb",
    "spec/fixtures/permits/super_admin_permit.rb",
    "spec/fixtures/permits/system_permit.rb",
    "spec/generators/cancan/license_generator_spec.rb",
    "spec/generators/cancan/licenses_generator_spec.rb",
    "spec/generators/cancan/permit_generator_spec.rb",
    "spec/generators/cancan/permits_generator_spec.rb",
    "spec/generic/api/basic/config.rb",
    "spec/generic/api/basic/xgroup.rb",
    "spec/generic/api/basic/xgroup_orm.rb",
    "spec/generic/api/owner/config.rb",
    "spec/generic/api/owner/xgroup.rb",
    "spec/generic/api/owner/xgroup_orm.rb",
    "spec/generic/models/all_models.rb",
    "spec/generic/owner_permits_spec.rb",
    "spec/generic/permits_spec.rb",
    "spec/generic/spec_helper.rb",
    "spec/mongo_mapper/models/all_models.rb",
    "spec/mongo_mapper/owner_permits_spec.rb",
    "spec/mongo_mapper/permits_spec.rb",
    "spec/mongo_mapper/spec_helper.rb",
    "spec/mongoid/models/all_models.rb",
    "spec/mongoid/owner_permits_spec.rb",
    "spec/mongoid/permits_spec.rb",
    "spec/mongoid/spec_helper.rb",
    "spec/simply_stored/CouchDB.txt",
    "spec/simply_stored/models/all_models.rb",
    "spec/simply_stored/owner_permits_spec.rb",
    "spec/simply_stored/permits_spec.rb",
    "spec/simply_stored/spec_helper.rb",
    "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/kristianmandrup/cancan-permits}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Permits for use with CanCan}
  s.test_files = [
    "spec/active_record/migrations/001_create_user.rb",
    "spec/active_record/migrations/002_create_comment.rb",
    "spec/active_record/migrations/003_create_post.rb",
    "spec/active_record/migrations/004_create_article.rb",
    "spec/active_record/models/all_models.rb",
    "spec/active_record/owner_permits_spec.rb",
    "spec/active_record/permits_spec.rb",
    "spec/active_record/spec_helper.rb",
    "spec/data_mapper/models/all_models.rb",
    "spec/data_mapper/owner_permits_spec.rb",
    "spec/data_mapper/permits_spec.rb",
    "spec/data_mapper/spec_helper.rb",
    "spec/fixtures/permits/admin_permit.rb",
    "spec/fixtures/permits/any_permit.rb",
    "spec/fixtures/permits/editor_permit.rb",
    "spec/fixtures/permits/guest_permit.rb",
    "spec/fixtures/permits/super_admin_permit.rb",
    "spec/fixtures/permits/system_permit.rb",
    "spec/generators/cancan/license_generator_spec.rb",
    "spec/generators/cancan/licenses_generator_spec.rb",
    "spec/generators/cancan/permit_generator_spec.rb",
    "spec/generators/cancan/permits_generator_spec.rb",
    "spec/generic/api/basic/config.rb",
    "spec/generic/api/basic/xgroup.rb",
    "spec/generic/api/basic/xgroup_orm.rb",
    "spec/generic/api/owner/config.rb",
    "spec/generic/api/owner/xgroup.rb",
    "spec/generic/api/owner/xgroup_orm.rb",
    "spec/generic/models/all_models.rb",
    "spec/generic/owner_permits_spec.rb",
    "spec/generic/permits_spec.rb",
    "spec/generic/spec_helper.rb",
    "spec/mongo_mapper/models/all_models.rb",
    "spec/mongo_mapper/owner_permits_spec.rb",
    "spec/mongo_mapper/permits_spec.rb",
    "spec/mongo_mapper/spec_helper.rb",
    "spec/mongoid/models/all_models.rb",
    "spec/mongoid/owner_permits_spec.rb",
    "spec/mongoid/permits_spec.rb",
    "spec/mongoid/spec_helper.rb",
    "spec/simply_stored/models/all_models.rb",
    "spec/simply_stored/owner_permits_spec.rb",
    "spec/simply_stored/permits_spec.rb",
    "spec/simply_stored/spec_helper.rb",
    "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 2.0.1"])
      s.add_development_dependency(%q<code-spec>, ["~> 0.2.9"])
      s.add_development_dependency(%q<rails-app-spec>, ["~> 0.3.1"])
      s.add_runtime_dependency(%q<cancan>, ["~> 1.4.1"])
      s.add_runtime_dependency(%q<require_all>, ["~> 1.2.0"])
      s.add_runtime_dependency(%q<sugar-high>, ["~> 0.3.0"])
      s.add_runtime_dependency(%q<rails3_artifactor>, ["~> 0.3.1"])
      s.add_runtime_dependency(%q<activesupport>, [">= 3.0.1"])
      s.add_runtime_dependency(%q<logging_assist>, [">= 0.1.6"])
    else
      s.add_dependency(%q<rspec>, [">= 2.0.1"])
      s.add_dependency(%q<code-spec>, ["~> 0.2.9"])
      s.add_dependency(%q<rails-app-spec>, ["~> 0.3.1"])
      s.add_dependency(%q<cancan>, ["~> 1.4.1"])
      s.add_dependency(%q<require_all>, ["~> 1.2.0"])
      s.add_dependency(%q<sugar-high>, ["~> 0.3.0"])
      s.add_dependency(%q<rails3_artifactor>, ["~> 0.3.1"])
      s.add_dependency(%q<activesupport>, [">= 3.0.1"])
      s.add_dependency(%q<logging_assist>, [">= 0.1.6"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 2.0.1"])
    s.add_dependency(%q<code-spec>, ["~> 0.2.9"])
    s.add_dependency(%q<rails-app-spec>, ["~> 0.3.1"])
    s.add_dependency(%q<cancan>, ["~> 1.4.1"])
    s.add_dependency(%q<require_all>, ["~> 1.2.0"])
    s.add_dependency(%q<sugar-high>, ["~> 0.3.0"])
    s.add_dependency(%q<rails3_artifactor>, ["~> 0.3.1"])
    s.add_dependency(%q<activesupport>, [">= 3.0.1"])
    s.add_dependency(%q<logging_assist>, [">= 0.1.6"])
  end
end

