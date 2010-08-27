# CanCan Permits

Adds the concept of centralized Permits for use with CanCan permission system. 

## Install

<code>gem install cancan-permits</code>

## Usage

* Define Roles that Users can have
* Define which Roles are available
* Define a Permit for each Role. 
* For each Permit, define what that Role can do

To add Roles to your app, you might consider using a *roles* gem such as *roles_generic*

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
  module RolePermit  
    class Admin < Base
      def initialize(ability)
        super
      end

      def permit?(user, request=nil)    
        super
        return if !role_match? user

        can :manage, :all    
      end  
    end
  end
</pre>

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
