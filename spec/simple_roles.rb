module ClassRoles

  def is_role_in_group?(role, group)
    raise "No group #{group} defined in User model" if !role_groups.has_key?(group)
    role_groups[group].include?(role) 
  end
  
  def role_groups
    {:bloggers => [:editor]} 
  end

  def roles
    [:guest, :admin, :editor]
  end    
  
end

module InstanceRoles
  def has_role? rolle
    role.to_sym == rolle
  end

  def has_any_role? roles
    roles.include?(role.to_sym)
  end

  def roles_list
    [role.to_sym]
  end

  def is_in_group? group
    self.class.is_role_in_group?(role,group)
  end

end


