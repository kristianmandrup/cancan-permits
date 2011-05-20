require 'cancan-permits/permit/util'
require_all File.dirname(__FILE__) + '/builder'

module Permits
  class Ability    
    include CanCan::Ability

    attr_reader :options, :user

    # put ability logic here! 
    # Equivalent to a CanCan Ability#initialize call 
    # which executes all the permission logic
    def initialize user, options = {}
      @user = user
      @user ||= Guest.create      
      @options = options

      # run permit executors
      all_permits.each do |permit|
        break if permit.execute(user, options) == :break
      end
    end      
    
    protected

    include Permit::Util
    
    def all_permits
      permits
    end
    
    def permits
      permit_builder.build!
    end

    def permit_builder
      @permit_builder ||= Permit::Builder.new self
    end    
  end
end      
