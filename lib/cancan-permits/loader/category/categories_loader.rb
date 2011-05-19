class CategoriesLoader
  
  attr_accessor :categories
  
  def initialize file_name    
    begin
      if file_name.nil? || !File.file?(file_name)
        return nil
      end

      yml_content = YAML.load_file(file_name)
      parser = CategoriesParser.new

      self.permissions ||= {}
      yml_content.each do |key, value|
        parser.parse(key, value) do |category|
          categories[category.name] = category
        end
      end
    rescue RuntimeError => e    
      raise "CategoriesLoader Error: The categories for the file #{file_name} could not be loaded - cause was #{e}"
    end
  end

  def self.load_categories name = nil
    name ||= categories_config_file
    CategoriesLoader.new name
  end
  
  def self.categories_config_file
    get_config_file 'categories'
  end
    
  protected

  def self.get_config_file name
    File.join(::Rails.root.to_s, 'config', "#{name}.yml") if rails?
  end
  
  def self.rails?
    defined?(Rails) && Rails.respond_to?(:root)
  end
end