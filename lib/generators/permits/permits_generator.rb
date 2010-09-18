require 'sugar-high/array'
require 'active_support/inflector'

class PermitsGenerator < Rails::Generators::Base
  desc "Creates a Permit for each role in 'app/permits' and ensures that the permit folder is added to Rails load path."

  class_option :roles,  :type => :array,    :default => [], :desc => "Roles to create permits for"
  # ORM to use
  class_option :orm,    :type => :string,   :desc => "ORM to use", :default => 'active_record'

  source_root File.dirname(__FILE__) + '/templates'

  def main_flow      
    template_permit :admin,   :admin_permit 
    template_permit :any,     :any_permit 
    template_permit :system,  :barebones_permit
    
    permit_logic = base_logic
    roles.each do |role|      
      template_permit role if !role == :admin     
    end    
  end
  
  protected

  attr_accessor :permit_name, :permit_logic

  # TODO: merge with any registered roles in application
  def roles
    options[:roles].uniq.to_symbols
  end

  def template_permit name, template_name=nil
    permit_logic = send "#{name}_logic" if [:admin, :system, :any].include?(name)
    self.permit_name = name

    template "permit.rb", "app/permits/#{name}_permit.rb"
    template "licenses.rb", "app/permits/licenses.rb"    
  end 

  def any_logic
    ""
  end

  def system_logic
    %{
      # allow to manage all and return :break to 
      # abort calling any other permissions
  
      if request.host.localhost? && localhost_manager?
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
end
