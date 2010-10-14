# CanCan Permits

Role specific Permits for use with [CanCan](http://github.com/ryanb/cancan) permission system.

## Update Oct 13

Now updated to support multiple ownership startegies so that alternative ORMs can be supported. 
This gem now includes specs that demonstrate how to configure it for use with Active Record, Data Mapper, Mongoid, Mongo Mapper 
Special thanks to Sam (yoda) for the initial inspiration and work to ensure support for Mongoid  :)

The generator has also been updated slightly to support this new strategy option as of version 0.2.1. 
In general, the new Permits API now uses an options hash to replace the old optional request parameter. 
This design allows for better extensibility in the future if needed. 

## Install

<code>gem install cancan-permits</code>

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

## Permits Generator

Options
* --orm   : The ORM to use (active_record, data_mapper, mongoid, mongo_mapper)
* --roles : The roles for which to generate permits ; default Guest (read all) and Admin (manage all) 

Note, by default the Permits generator will attempt to discover which roles are currently defined as available to the system
and generate permits for those roles (using some conventions - TODO). Any roles specified in the --roles option are merged
with the roles found to be available in the app.

<code>$ rails g permits --orm active_record --roles guest author admin</code>

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
