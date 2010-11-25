# CanCan Permits

Role specific Permits for use with [CanCan](http://github.com/ryanb/cancan) permission system.

## Changes

See Changelog.txt (Major updates as per Nov 24. 2010)

## Install

<code>gem install cancan-permits</code>

## Usage Rails 3 app

Gemfile
<code>gem 'cancan-permits'</code>

Update gem bundle in terminal:
<code>$ bundle install</code>

See Generator section below. Also see [CanCan permits demo app](https://github.com/kristianmandrup/cancan-permits-demo)

## Usage

* Define Roles that Users can have
* Define which Roles are available
* Define a Permit for each Role. 
* For each Permit, define what that Role can do

To add Roles to your app, you might consider using a *roles* gem such as [Roles Generic](http://github.com/kristianmandrup/roles_generic) or any of the ORM specific variants.

### Define which Roles are available

You can override the default configuration here:

<pre>
  module Permits::Roles
    def self.available
      # return symbols array of Roles available to users 
    end
  end
</pre>  

By default it returns User.roles if such exists, otherwise it returns [:guest, :admin] by default.

### Define a Permit for each Role. 

_Note:_ You might consider using the Permits generator in order to generate your permits for you (see below)

<pre>
  class AdminPermit < Permit::Base
    def initialize(ability, options = {})
      super
    end

    def permit?(user, options = {})    
      super
      return if !role_match? user

      can :manage, :all    
    end  
  end
</pre>

## Special Permits

The Permits generator always generates the special permits *Any* and *System*.

### Any permit

The Any permit, can be used to set permissions that should hold true for a user in any role. 
F.ex, maybe in your app, any user should be able to read comments, articles and posts:

For this to hold true, put the following permit logic in your Any permit.
<pre>
  can :read, [Comment, Article, Post]
</pre>

### System permit

The System permit is run before any of the other permits. This gives you a chance to control the permission flow.
By returning a value of :break you force a break-out from the permission flow, ensuring none of the other permits are run.

Example:
The system permit can be used to allow management of all resources given the request is from localhost (which usually means "in development mode"). By default this logic is setup and ready to go. 

You can be enable this simply by setting the following class instance variable: 

<code>Permits::Configuration.localhost_manager = true</code>

## Default roles

By default the permits for the roles System and Guest are also generated.

### Licenses

Permits also supports creation more fine-grained permits through the use of Licenses.  
Licenses are a way to group logical fragments of permission statements to be reused across multiple permits.
The generator will create a licenses.rb file in the permits folder where you can put your licenses. For more complex scenarios, you might want to have a separate
licenses subfolder where you put your license files.

License example:
<pre>
  class BloggingLicense < License::Base
    def initialize name
      super
    end

    def enforce!
      can(:read, Blog)
      can(:create, Post)
      owns(user, Post)
    end
  end  
</pre>

Usage example:

<pre>
  class GuestPermit < Permit::Base
    def initialize(ability, options = {})
      super
    end

    def permit?(user, options = {}) 
      super    
      return if !role_match? user

      licenses :user_admin, :blogging
    end
  end
end
</pre>

By convention the permits system will try to find a license named UserAdminLicense and BloggingLicense in this example and call enforce! on each license.

## ORMs

The easiest option is to directly set the orm as a class variable. An appropriate ownership strategy will be selected accordingly for the ORM. 

<pre>
  Permits::Ability.orm = :data_mapper
</pre>

Alternatively set it for the Ability instance for more fine grained control
<pre>
  ability = Permits::Ability.new(@editor, :strategy => :string)  
</pre>

The ORMs currently supported (and tested) are :active_record, :data_mapper, :mongoid, :mongo_mapper

## Advanced Permit options

Note that the options hash (second argument of the initializer) can also be used to pass custom data for the permission system to use to determine whether an action
should be permitted. An example use of this is to pass in the HTTP request object. This approach is used in the default SystemPermit generated.

The ability would most likely be configured with the current request in a view helper or directly from within the controller.

<code>
  editor_ability = Permits::Ability.new(@editor, :request => request)      
</code>

A Permit can then use this information
 
<code>
  def permit?(user, options = {}) 
    request = options[:request]
    if request && request.host.localhost? && localhost_manager?
      can(:manage, :all) 
      return :break
    end    
  end  
</code>

Now, if a request object is present and the host is 'localhost' and Permits has been configured to allow localhost to manage objects, then:
The user is allowed to manage all objects and no other Permits are evaluated (to avoid them overriding this full right permission).

In the code above, the built in <code>#localhost_manager?</code> method is used.

To configure permits to allow localhost to manage objects:
<code>
  Permits::Configuration.localhost_manager = true
</code>

Please provide suggestions and feedback on how to improve this :)

## Permits Generator

Options
* --orm         : The ORM to use (active_record, data_mapper, mongoid, mongo_mapper) - creates a Rails initializer
* --initializer : A Rails 3 initializer file for Permits is generated by default. Use --no-initializer option to disable this
* --roles       : The roles for which to generate permits ; default Guest (read all) and Admin (manage all) 
* --licenses    : The licenses to generate; default UserAdmin and Blogging licenses are generated

* --default-licenses  : By default exemplar licenses are generated. Use --no-default-licenses option to disable this
* --default-permits   : By default :guest and :admin permits are generated. Use --no-default-permits option to disable this

<code>$ rails g permits --orm active_record --roles guest author admin</code>

### What does the generator generate?

To get an understanding of what the generator generates for a Rails 3 application, try to run the spec permit_generator_spec.rb with rspec 2 as follows:

<code>$ rspec spec/generators/permit_generator_spec.rb</code>

In the file <code>permit_generator_spec.rb</code> make the following change <code>config.remove_temp_dir = false</code>
This will prevent the rails /tmp dir from being deleted after the test run, so you can inspect what is generated in the Rails app. 

# TODO ?

The Permits generator should attempt to discover which roles are currently defined as available to the system (Generic Roles API, User#roles etc.) and generate permits for those roles. Any roles specified in the --roles option should be merged with the roles available in the app.

## Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2010 Kristian Mandrup. See LICENSE for details.
