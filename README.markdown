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

## Permits configuration

Permits can be configured [using permits configuration files](https://github.com/kristianmandrup/cancan-permits/wiki/Using-permits-configuration-files)

### Users, roles and permissions

_CanCan permits_ requires that you have some kind of 'role system' in place and that _User#has_role?_ returns whether the user has a given role (pass role argument as symbol or string). You can either add a 'role' directly to the _User_ class or fx use a [Roles Generic](https://github.com/kristianmandrup/roles_generic) role strategy.

## Application configuration for CanCan Permits

* Define roles that Users can have
* Define which roles are available
* Define a Permit for each role. 
* For each Permit, define what Users with a role matching the permit can do

To add roles to your app, you might consider using a *roles* gem such as [Roles Generic](http://github.com/kristianmandrup/roles_generic) or any of the ORM specific variants.

CanCan permits is integrated with [CanCan REST links](https://github.com/kristianmandrup/cancan-rest-links), letting you easily control which users have access to which models in your app.

Note that [Cream](https://github.com/kristianmandrup/cream) has a _full_config_ generator that automatically configures all this for you in a standard configuration which integrates all the various parts (and even supports multiple ORMs) !!!

### Define which roles are available

_CanCan permits_ uses the following strategy to discover which roles are available in the app.

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
    return if !role_match? user    

    can(:read, Blog)
    can(:manage, Article)
    owns(user, Post)        
  end  
end
</pre>

Alternatively you can use <code>return if !super user, :in_role</code> to exit if the user doesn't have a role that matches the Permit.
This will in effect execute the same test. 

Permit for Role group:

Permit example:
<pre>class BloggersPermit < Permit::Base
  def initialize(ability, options = {})
    super
  end

  def permit?(user, options = {})    
    return if !role_group_match? user    

    can(:read, Blog)
    can(:manage, Article)
    owns(user, Post)        
  end  
end
</pre>

Here the name of the Role group 'Bloggers' is used as the prefix in the class name. In the #permit? method the #role_group_match? is used to ensure the permissions
are only granted if the user is a member of this group.

_Ownership permission:_

The _owns_ call is a special built-in way to define ownership permission. The #_owns_ call can also pe used inside Permits. 
If a user owns an object instance that user will automatically have :manage permissions to that object instance.

### Special permits

The Permits system uses some [special permits](https://github.com/kristianmandrup/cancan-permits/wiki/Special-permits) that can be configured for
avanced permission scenarios as described in the wiki.

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

Licenses usage example:
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

## Using Permits with an ORM

The easiest option is to directly set the orm as a class variable. An appropriate 'ownership strategy' will be selected accordingly for the ORM. 

<pre>
  Permits::Ability.orm = :data_mapper
</pre>

The ORMs currently supported (and tested) are :active_record, :data_mapper, :mongoid, :mongo_mapper

For more fine grained control, you can set a :strategy option directly on the Ability instance. This way the ownership strategy is set explicitly.
The current valid values are _:default_ and _:string_.

The strategy option :string can be used for most ORMs. Setting _orm__ to _:active_record_ or _:generic_ makes use of the _:default_ strategy. 
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

### Configuring global management permission for localhost

The Permits system allows a global setting in order to allow localhost to manage all objects. This can be useful in development or administration mode. 

To configure permits to allow localhost to manage objects:
<code>
  Permits::Configuration.localhost_manager = true
</code>

Assuming the following:
- a request object is present 
- the host of the request is 'localhost' 
- Permits::Configuration has been configured to allow localhost to manage objects:

Then the user is allowed to manage all objects and no other Permits will be evaluated to restrict further.

Note: In the code above, the built in <code>#localhost_manager?</code> method is used.

_Please provide suggestions and feedback on how to improve this :)_

## Generators

The gem comes with the following generators

* cancan:permits - generate multiple permits
* cancan:permit - generate a single permit
* cancan:licenses - generate multiple licenses
* cancan:license - generate a single license

The generators are described in detail [here](https://github.com/kristianmandrup/cancan-permits/wiki/Permits-and-License-generators)

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
