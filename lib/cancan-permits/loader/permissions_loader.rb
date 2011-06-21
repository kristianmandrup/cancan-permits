module Permits
  module Loader
    class Permissions  
      attr_accessor :permissions, :file_name
  
      def initialize file    
        begin          
          self.file_name = file
          yml_content.each do |key, value|
            parser.parse(key, value) do |permission|
              permissions[permission.name] = permission
            end
          end
        rescue RuntimeError => e    
          raise "PermissionsLoader Error: The permissions for the file #{file_name} could not be loaded - cause was #{e}"
        end
      end

      def file_name= file
        return nil if file.nil? || !File.file?(file)
        @file_name = file
      end

      def yml_content
        YAML.load_file(file_name)
      end
      
      def permissions
        @permissions ||= {}
      end

      def parser
        @parser ||= Permits::Parser::Permissions.new
      end

      module ClassMethods
        def load_user_permissions name = nil
          name ||= user_permissions_config_file
          Permits::Loader::Permissions.new name
        end

        def load_licenses name = nil
          name ||= licenses_config_file
          Permits::Loader::Permissions.new name
        end

        def load_permits name = nil
          name ||= permits_config_file
          Permits::Loader::Permissions.new name
        end
        
        def load_groups_permits name=nil
          name ||= groups_permits_config_file
          Permits::Loader::Permissions.new name
        end

        def groups_permits_config_file
          get_config_file 'groups_permits'
        end

        def permits_config_file
          # raise '#user_permissions_config_file only works in a Rails app enviroment' if !defined? Rails
          get_config_file 'permits'
        end
  
        def user_permissions_config_file
          # raise '#user_permissions_config_file only works in a Rails app enviroment' if !defined? Rails
          get_config_file 'user_permissions'
        end

        def licenses_config_file
          # raise '#licenses_config_file only works in a Rails app enviroment' if !defined? Rails
          get_config_file 'licenses'
        end
      
        protected

        def get_config_file name
          File.join(::Rails.root.to_s, 'config', "#{name}.yml") if rails?
        end
  
        def rails?
          defined?(::Rails) && ::Rails.respond_to?(:root)
        end
      end
      
      extend ClassMethods
    end
  end
end
