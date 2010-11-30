class PermissionsLoader
  
  attr_accessor :permissions
  
  def initialize file_name    
    begin
      if file_name.nil? || !File.file?(file_name)
        # raise ArgumentError, "PermissionsLoader Error: The permissions file #{file_name} could not be found" 
        # puts "PermissionsLoader Error: The permissions file #{file_name} could not be found" 
        return nil
      end

      yml_content = YAML.load_file(file_name)
      parser = PermissionsParser.new

      self.permissions ||= {}
      yml_content.each do |key, value|
        parser.parse(key, value) do |permission|
          permissions[permission.name] = permission
        end
      end
    rescue RuntimeError => e    
      raise "PermissionsLoader Error: The permissions for the file #{file_name} could not be loaded - cause was #{e}"
    end
  end

  def self.load_user_permissions name = nil
    name ||= user_permissions_config_file
    PermissionsLoader.new name
  end

  def self.load_licenses name = nil
    name ||= licenses_config_file
    PermissionsLoader.new name
  end

  def self.load_permits name = nil
    name ||= permits_config_file
    PermissionsLoader.new name
  end
  
  def self.permits_config_file
    # raise '#user_permissions_config_file only works in a Rails app enviroment' if !defined? Rails
    get_config_file 'permits'
  end
  
  def self.user_permissions_config_file
    # raise '#user_permissions_config_file only works in a Rails app enviroment' if !defined? Rails
    get_config_file 'user_permissions'
  end

  def self.licenses_config_file
    # raise '#licenses_config_file only works in a Rails app enviroment' if !defined? Rails
    get_config_file 'licenses'
  end
  
  protected

  def self.get_config_file name
    File.join(::Rails.root, 'config', "#{name}.yml") if rails?
  end
  
  def self.rails?
    defined?(Rails) && Rails.respond_to?(:root)
  end
end