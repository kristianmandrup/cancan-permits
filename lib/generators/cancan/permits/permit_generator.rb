require 'rails/generators/base'
require 'sugar-high/array'
require 'active_support/inflector'
require 'rails3_artifactor'
require 'logging_assist'

module Cancan
  module Generators
    class PermitGenerator < Rails::Generators::Base
      desc "Creates a Permit for a role in 'app/permits' with specific permissions and/or licenses"

      argument     :role,        :type => :string,      :default => '',               :desc => "Role to create permit for"

      class_option :licenses,     :type => :array,     :default => [],  :desc => "Licenses to use in Permit"

      class_option :manages,      :type => :array,     :default => [],  :desc => "Models allowed to manage"
      class_option :reads,        :type => :array,     :default => [],  :desc => "Models allowed to read"
      class_option :owns,         :type => :array,     :default => [],  :desc => "Models allowed to own"

      source_root File.dirname(__FILE__) + '/templates'

      def main_flow      
        return nil if role.empty?
        template_permit
      end
  
      protected

      include Rails3::Assist::BasicLogger
      
      def manages
        options[:manages]
      end

      def licenses
        options[:licenses]
      end

      def reads
        options[:reads]
      end

      def owns
        options[:owns]
      end

      def template_permit        
        template "role_permit.rb", "app/permits/#{role}_permit.rb"
      end 

      def logic
        [:create, :manage, :own, :read, :license].map do |action|
          send :"#{action}_logic"
        end.join("\n    ")
      end

      [:create, :manage, :own, :read].each do |action|
        class_eval %{
          def #{action}_logic
            creates.map{|c| "can(:#{action}, \#{act_model(c)})"}.join("\n    ")
          end          
        }
      end

      def license_logic
        return '' if licenses.empty?
        ls = licenses.map{|c| ":#{c}"}.join(", ")
        "licenses #{ls}"
      end  
    end
  end
end