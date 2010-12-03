class PermissionSet
  attr_accessor :read, :write, :update, :manage, :create, :delete
  
  # def to_yaml
  #   hash = {}
  #   [:read, :write, :update, :manage, :create, :delete].each do |action|
  #     hash[action] = self.action      
  #   end
  # end
end