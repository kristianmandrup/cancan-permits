begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "cancan-permits"
    gem.summary = %Q{Permits for use with CanCan}
    gem.description = %Q{Role specific Permits for use with CanCan permission system}
    gem.email = "kmandrup@gmail.com"
    gem.homepage = "http://github.com/kristianmandrup/cancan-permits"
    gem.authors = ["Kristian Mandrup"]
    gem.add_development_dependency "rspec",           ">= 2.0.1"
    gem.add_development_dependency 'code-spec',       "~> 0.2.9"
    gem.add_development_dependency 'rails-app-spec',  "~> 0.3.1"

    gem.add_dependency 'cancan',            "~> 1.4.1"
    gem.add_dependency 'require_all',       "~> 1.2.0"
    gem.add_dependency 'sugar-high',        "~> 0.3.0"
    gem.add_dependency 'rails3_artifactor', "~> 0.3.1"
    gem.add_dependency 'activemodel',     ">= 3.0.1"
    gem.add_dependency 'activesupport',     ">= 3.0.1"
    gem.add_dependency 'activeresource',     ">= 3.0.1"
    gem.add_dependency 'logging_assist',    ">= 0.1.6"
    
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

