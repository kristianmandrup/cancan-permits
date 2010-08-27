require 'sugar-high/array'

class PermitsGenerator < Rails::Generators::Base
  desc "Creates a Permit for each role in 'app/permits' and ensures that the permit folder is added to Rails load path."

  class_option :roles,  :type => :array,    :default => [], :desc => "Roles to create permits for"
  # ORM to use
  class_option :orm,    :type => :string,   :desc => "ORM to use", :default => 'active_record'

  source_root File.dirname(__FILE__) + '/templates'

  def main_flow      
    template_permit :admin, :admin_permit
    roles.each do |role|
      template_permit role if !role == :admin     
    end    
  end
  
  protected

  # TODO: merge with any registered roles in application
  def roles
    options[:roles].uniq.to_symbols
  end

  def template_permit name, template_name=nil
    template "#{template_name || :permit}.rb", "app/permits/#{name}_permit.rb"
  end
end
