require 'rails/generators/base'
require 'sugar-high/array'
require 'active_support/inflector'
require 'rails3_artifactor'
require 'logging_assist'

class PermitsGenerator < Rails::Generators::Base
  desc "Creates a Permit for each role in 'app/permits' and ensures that the permit folder is added to Rails load path."

  class_option :roles,        :type => :array,      :default => [],               :desc => "Roles to create permits for"
  class_option :licenses,     :type => :array,      :default => [],               :desc => "Licenses"

  # ORM to use
  class_option :orm,          :type => :string,     :default => 'active_record',  :desc => "ORM to use"
  class_option :initializer,  :type => :boolean,    :default => true,             :desc => "Create Permits initializer"

  class_option :default_permits,    :type => :boolean,    :default => true, :desc => "Create default permits for guest and admin roles"
  class_option :default_licenses,   :type => :boolean,    :default => true, :desc => "Create default exemplar licenses"

  source_root File.dirname(__FILE__) + '/templates'

  def main_flow      
    default_roles.each do |role|
      template_permit role
    end

    template_permit :any,     :any_permit 
    template_permit :system,  :barebones_permit
    
    permit_logic = base_logic
    roles.each do |role|      
      template_permit(role) if !skip_permit?(role)
    end    

    if default_licenses?
      template_license :user_admin
      template_license :blogging
    end  

    licenses.each do |license|      
      template_license(license) if !skip_license?(license)
    end    

    permits_initializer if permits_initializer?
  end
  
  protected

  include Rails3::Assist::BasicLogger
  extend Rails3::Assist::UseMacro
  
  use_helpers :app, :file, :special

  attr_accessor :permit_name, :permit_logic

  def default_roles
    [:guest, :admin]
  end

  def permits_initializer?
    options[:initializer]
  end

  def skip_license? license
    default_licenses? && default_licenses.include?(license.to_sym) 
  end

  def skip_permit? permit
    default_permits? && default_roles.include?(permit.to_sym) 
  end


  # TODO: merge with any registered roles in application
  def roles
    options[:roles].uniq.to_symbols
  end

  def default_licenses?
    options[:default_licenses]    
  end

  def default_permits?
    options[:default_permits]    
  end

  def licenses
    options[:licenses]    
  end
  
  def orm
    options[:orm]
  end

  def permits_initializer
    create_initializer :permits do 
      "Permits::Ability.orm = :#{orm}"
    end
  end 

  def template_license name 
    template "#{name}_license.rb", "app/licenses/#{name}_license.rb"
  end

  def template_permit name, template_name=nil
    permit_logic = send "#{name}_logic" if [:admin, :system, :any].include?(name)
    self.permit_name = name

    template "permit.rb", "app/permits/#{name}_permit.rb"
  end 

  def any_logic
    ""
  end

  def system_logic
    %{
      # allow to manage all and return :break to 
      # abort calling any other permissions
  
      request = options[:request]
      if request && request.host.localhost? && localhost_manager?
        can(:manage, :all) 
        return :break
      end    
}
  end

  def base_logic
    %{
      return if !role_match? user

      # can :create, Comment
      # owns(user, Comment)
}
  end
  
  def admin_logic
    %{
      return if !role_match? user
      can :manage, :all
}
  end

    def guest_logic
      %{
        return if !role_match? user
        can :read, :all
  }
    end
end
