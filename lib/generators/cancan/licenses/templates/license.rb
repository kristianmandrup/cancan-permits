class <%= role.to_s.camelize %>License < License::Base
  def initialize name
    super
  end
  
  def enforce!
    <%= logic %>
  end  
end
