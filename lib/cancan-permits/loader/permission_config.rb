class PermissionConfig
  attr_accessor :name, :can, :cannot  
  
  def initialize name
    @name = name
  end  

  # Should take @can={"manage"=>["all"]}, @cannot={"update"=>["User", "Profile"]}
  # and create string ready to ruby evaluate like:
  # can(:manage, :all)
  # cannot(:update, [User, Profile]) 
  def can_eval &block
    return nil if !can
    statements = [:manage, :read, :update, :create, :write].map do |action|
      targets = can[action.to_s]
      targets ? "can(:#{action}, #{parse_targets(targets)})" : nil
    end.compact.join("\n")
    yield statements if !statements.empty? && block
  end

  def cannot_eval &block
    return nil if !cannot
    statements = [:manage, :read, :update, :create, :write].map do |action|
      targets = cannot[action]
      targets ? "cannot(:#{action}, #{parse_targets(targets)})" : nil
    end.compact.join("\n")
    yield statements if !statements.empty? && block
  end
  
  def parse_targets targets
    targets.map do |target|
      if target == 'all'
        :all
      else
        begin
          target #.constantize
        rescue
          puts "[permission] target #{target} does not have a class so it was skipped"
        end
      end
    end
  end
end
