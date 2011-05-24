module Permits
  module Loader
    class Categories  
      attr_accessor :categories
  
      def initialize file    
        begin
          file_name = file                   
          yml_content.each do |key, value|
            parser.parse(key, value) do |category|
              categories[category.name] = category
            end
          end
        rescue RuntimeError => e    
          raise "CategoriesLoader Error: The categories for the file #{file_name} could not be loaded - cause was #{e}"
        end
      end

      def file_name= file
        return nil if file.nil? || !File.file?(file)
        @file_name = file
      end

      def yml_content
        YAML.load_file(file_name)
      end

      def categories
        @categories ||= {}
      end
          
      def parser
        @parser ||= Permits::Parser::Categories.new
      end
      
      module ClassMethods
        def load_categories name = nil
          name ||= categories_config_file
          CategoriesLoader.new name
        end
  
        def categories_config_file
          get_config_file 'categories'
        end
    
        protected

        def get_config_file name
          File.join(::Rails.root.to_s, 'config', "#{name}.yml") if rails?
        end
  
        def rails?
          defined?(Rails) && Rails.respond_to?(:root)
        end
      end
    end
  end
end