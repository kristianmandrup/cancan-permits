# CanCan Permits

Role specific Permits for use with [CanCan](http://github.com/ryanb/cancan) permission system.

## Install

<code>gem install cancan-permits</code>

## Usage Rails 3 app

Gemfile
<code>gem 'cancan-permits'</code>

Update gem bundle in terminal:
<code>$ bundle install</code>

See Generator section below. 

See [CanCan permits demo app](https://github.com/kristianmandrup/cancan-permits-demo) for more info on how to set up a Rails 3 app with CanCan permits!

## Rails 3 configuration

Note: This description does not apply to how CanCan-permits is used with [Cream](https://github.com/kristianmandrup/cream)

Create a rails initializer with the following code:

<pre>module Cream
  # specify all roles available in your app!
  def self.available_roles
    [:guest, :admin]
  end
end  
</pre>

Modify the User model in 'models/user.rb' (optional)

<pre>class User
  def self.roles
    Cream.available_roles
  end   
  
  def has_role? role
    (self.role || 'guest').to_sym == role.to_sym
  end       
end
</pre>

## Load Permissions from yaml files

Permissions can be defined in yaml files in the config directory of your Rails app.
These permissions will then be applied at the appropriate point when calculation permissions of the user.

* Individual user permissions
* Permits
* Licenses

### Permission editor

A simple [Permits editor](https://github.com/kristianmandrup/permits_editor) is available. This is a Rails 3 app which provides a web interface to
edit the permits config files for: user permissions, permits and licenses.

I would like to have this editor refactored into an engine and later into a mountable app so that this administrative interface can easily be integrated into a Cream app.

_You are most welcome to help in this effort ;)_

### Individual user permissions

You can define individual user permissions in a yaml file.
                  
YAML file: _config/user_permissions.yml_

Each key at the top level is expected to match an email value for a user.

Example yaml config file:
<pre>abc@mail.ru:
  can:
    update: [Comment, Fruit, Car, Friendship]        
    manage: 
      - Article
    owns: 
      - User
mike.shedlock@acc.com:
  can:
    read:
      - all
  cannot:
    update:
      - Post
</pre>

Loading YAML user_permits file in a Permit:
<pre>class AdminPermit < Permit::Base
  def initialize(ability, options = {})
    super
  end

  def permit?(user, options = {})
    super
    return if !role_match? user
    can :manage, :all          

    load_rules user
  end  
end
</pre>

The call to #load_rules will call both _#load_user_roles_ and _#load_role_rules_. Hence by default it applies both the _user_permits_ and _permits_ config files. 
If you want, you can call these methods individually in case only want to apply one set of rules.

### Permit rules

YAML file: _config/permits.yml_

Each key at the top level is expected to match a permit/role name.

Example yml config file:
<pre>admin:
  can:
    manage:
      - Article
      - Post
guest:
  can:
    manage:
      - all
  cannot:
    manage:
      - User  
</pre>

As you can see

### License permissions 

YAML file: _config/licenses.yml_

Each key at the top level is expected to match a license name.

Example yml config file:

<pre>blogging:
  can:
    manage:
      - Article
      - Post
admin:
  can:
    manage:
      - all
  cannot:
    manage:
      - User  
</pre>

Usage in a license:
<pre>class UserAdminLicense < License::Base
  def initialize name
    super
  end

  def enforce!
    can(:manage, User)

    load_rules
  end  
</pre>

### User Roles

_CanCan permits_ requires that you have some kind of Role system in place and that User#has_role? uses this Role system.
You can either add a 'role' field directly to User or fx use a [Roles Generic ](https://github.com/kristianmandrup/roles_generic) role strategy.

## Usage

* Define Roles that Users can have
* Define which Roles are available
* Define a Permit for each Role. 
* For each Permit, define what that Role can do

To add Roles to your app, you might consider using a *roles* gem such as [Roles Generic](http://github.com/kristianmandrup/roles_generic) or any of the ORM specific variants.

### Define which Roles are available

Default configuration:
<pre>module Permits::Roles
  def self.available
    if defined? ::Cream
      Cream.available_roles
    elsif defined? ::User
      User.roles
    else
      [:admin, :guest]
    end
  end
end
</pre>

_CanCan permits_ will first try to assume it is used with Cream. If not it will fallback to try and get the roles from User#roles. 
If all else fails, it will assume only the :guest and :admin roles are available. 

You can always monkeypatch this configuration implementation to suit your own needs.

### Define a Permit for each Role. 

You can use the _Permits generator_ to generate your permits. Permits should be placed in the app/permits folder.

Permit example:
<pre>class AdminPermit < Permit::Base
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
<pre>can :read, [Comment, Article, Post]</pre>

### System permit

The System permit is run before any of the other permits. This gives you a chance to control the permission flow.
By returning a value of :break you force a break-out from the permission flow, ensuring none of the other permits are run.

Example:
The system permit can be used to allow management of all resources when the request is from localhost (which usually means "in development mode"). 
By default this logic is setup and ready to go. 

You can configure this simply by setting the following boolean class variable: 

<code>Permits::Configuration.localhost_manager = true</code>

## Default roles

By default the permits for the roles System and Guest are also generated.

### Licenses

Permits support creation of more fine-grained permits through the use of _Licenses_.  
Licenses are a way to group logical fragments of permission statements to be reused across multiple Permits.

You can use the _License generator_ to generate your licenses. Lincenses should be placed in the _app/licenses_ folder.

License example:
<pre>class BloggingLicense < License::Base
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
<pre>class GuestPermit < Permit::Base
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

The permits system will try to find a license named UserAdminLicense and BloggingLicense in this example and then call _#enforce!_ on each license.

## ORMs

The easiest option is to directly set the orm as a class variable. An appropriate ownership strategy will be selected accordingly for the ORM. 

<pre>
  Permits::Ability.orm = :data_mapper
</pre>

The ORMs currently supported (and tested) are :active_record, :data_mapper, :mongoid, :mongo_mapper

For more fine grained control, you can set a :strategy option directly on the Ability instance. This way the ownership strategy is set explicitly.
The current valid values are :default and :string.

The strategy option :string can be used for most ORMs. Setting orm to :active_record or :generic makes use of the :default strategy. 
All the other ORMs use the :string ownership strategy,

Note: You can dive into the code and implement your own strategy if needed.

Setting the ownership strategy directly:
<pre>ability = Permits::Ability.new(@editor, :strategy => :string)</pre>

## Advanced Permit options

Note that the options hash (second argument of the initializer) can also be used to pass custom data for the permission system to use to determine whether an action
should be permitted. An example use of this is to pass in the HTTP request object. This approach is used in the default SystemPermit generated.

The ability would most likely be configured with the current request in a view helper or directly from within the controller.

<code>editor_ability = Permits::Ability.new(@editor, :request => request)</code>

A Permit can then use this extra information

Advanced #permit? functionality:  
<pre>def permit?(user, options = {}) 
  request = options[:request]
  if request && request.host.localhost? && localhost_manager?
    can(:manage, :all) 
    return :break
  end    
end  
</pre>

### Global manage permission for localhost

The Permits system allows a global setting in order to allow localhost to manage all objects. This can be useful in development or administration mode. 

To configure permits to allow localhost to manage objects:
<code>
  Permits::Configuration.localhost_manager = true
</code>

Please provide suggestions and feedback on how to improve this :)

Assuming the following:
- a request object is present 
- the host of the request is 'localhost' 
- Permits::Configuration has been configured to allow localhost to manage objects:

Then the user is allowed to manage all objects and no other Permits will be evaluated to restrict further.

Note: In the code above, the built in <code>#localhost_manager?</code> method is used.

## Generators

The gem comes with the following generators

* cancan:permits - generate multiple permits
* cancan:permit - generate a single permit
* cancan:licenses - generate multiple licenses
* cancan:license - generate a single license

## Permits Generator

Generates one or more permits in _app/permits_

Options
* --orm             : The ORM to use (active_record, data_mapper, mongoid, mongo_mapper) - creates a Rails initializer
* --initializer     : A Rails 3 initializer file for Permits is generated by default. Use --no-initializer option to disable this
* --roles           : The roles for which to generate permits ; default Guest (read all) and Admin (manage all) 
* --default-permits : By default :guest and :admin permits are generated. Use --no-default-permits option to disable this

<code>$ rails g cancan:permits --orm active_record --roles guest author admin</code>

### What does the generator generate?

To get an understanding of what the generator generates for a Rails 3 application, try to run the spec _permit_generator_spec.rb_ with _RSpec 2_ as follows:

In the file _permits_generator_spec.rb_ make the following change <code>config.remove_temp_dir = false</code>
This will prevent the rails /tmp dir from being deleted after the test run, so you can inspect what is generated in the Rails app. 

Now run the generator spec to see the result:
<code>$ rspec spec/generators/cancan/permits_generator_spec.rb</code>

## Licenses Generator

Generates one or more licenses in _app/licenses_

Options
* --licenses    : The licenses to generate; default UserAdmin and Blogging licenses are generated
* --default-licenses  : By default exemplar licenses are generated. Use --no-default-licenses option to disable this

Run examples:

Generate default licenses:

<code>$ rails g cancan:licenses</code>

Genereate specific licenses (no defaults):

<code>$ rails g cancan:licenses profile_administration article_editing --no-default-licenses</code>

Create both specific and default licenses:

<code>$ rails g cancan:licenses profile_administration article_editing</code>

### What does the generator generate?

To get an understanding of what the generator generates for a Rails 3 application, try to run the spec _licenses_generator_spec.rb_ with rspec 2 as follows:

In the file _licenses_generator_spec.rb_ make the following change <code>config.remove_temp_dir = false</code>
This will prevent the rails /tmp dir from being deleted after the test run, so you can inspect what is generated in the Rails app. 

Now run the generator spec to see the result:
<code>$ rspec spec/generators/cancan/licenses_generator_spec.rb</code>


## License Generator

Generates a single license in _app/licenses_

<code>rails g cancan:license [NAME]</code>

Options
* --creates : The models that have 'creates' permission for the holder of this license 
* --owns    : The models that have 'owns' permission for the holder of this license 
* --manages : The models that have 'manages' permission for the holder of this license 
* --read    : The models that have 'read' permission for the holder of this license 

Run examples:

Generate licenses:

<code>$ rails g cancan:license blog_editing --owns article post --read blog --licenses blogging</code>

## Permit Generator

Generates a single license in _app/permits_

<code>rails g cancan:permit [ROLE]</code>

Options
* --creates : The models that have 'creates' permission for the holder of this license 
* --owns    : The models that have 'owns' permission for the holder of this license 
* --manages : The models that have 'manages' permission for the holder of this license 
* --read    : The models that have 'read' permission for the holder of this license 

Run examples:

Generate licenses:

<code>$ rails g cancan:permit editor --owns article post --read blog --licenses blog_editing</code>

# TODO

The Permits generator should attempt to attempt to uncover which roles are currently defined as available to the system, trying Cream#available_roles and then User#roles. It could then generate permits for those roles. Any roles specified in the --roles option should be merged with the roles available in the app.

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
