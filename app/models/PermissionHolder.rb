# require 'psych'

class PermissionHolder
  has_one :can,     :class_name => 'PermissionSet'
  has_one :cannot,  :class_name => 'PermissionSet'
  
  accepts_nested_atributes_for :can, :cannot
  
  def save_to_yaml
    yaml_content = load_yaml(file_name)
    yaml_content[name][:can] = can.to_yaml
    yaml_content[name][:cannot] = cannot.to_yaml
    yaml_content.save(file_name)    
  end

  def load_from_yaml
    yaml_content = load_yaml(file_name)    
    self.can = yaml_content[name][:can]
    self.cannot = yaml_content[name][:can]
  end
  
  def remove_from_yaml
    yaml_content = load_yaml(file_name)
    yaml_content[name] = ''
    yaml_content.save(file_name)
  end
  
  protected
  
  def file_name
    self.class.to_s.underscore.pluralize + '.yaml'
  end  
end
