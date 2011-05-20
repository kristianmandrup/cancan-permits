require 'cancan-permits/permit/util'

module Permits
  class Ability    
    include CanCan::Ability

    def initialize user, options = {}
      # put ability logic here!
      user ||= Guest.create      

      all_permits(options).each do |permit|
        permit.execute user, options
      end
    end      

    # TODO: into class_methods file?
    class << self
     attr_accessor :orm, :strategy

     # set up each Permit instance to share this same Ability 
     # so that the can and cannot operations work on the same permission collection!
     def permits ability, options = {}
       permit_builder.build!(ability, options)
     end

     # BAD!
     def orm= orm
       @orm = orm 
       case orm
       when :active_record, :generic
         @strategy = :default
       else
         @strategy = :string
       end
     end
    end
    
    protected

    include Permit::Util
    
    def all_permits options
      Permits::Ability.permits(self, options)
    end
  end
end      
