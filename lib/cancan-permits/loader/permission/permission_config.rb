class PermissionConfig
  attr_accessor :name, :can, :cannot  
  attr_accessor :categories

  # categories - a CategoriesConfig instance from after loading categories file  
  def initialize name, categories = {}
    @name = name
    @categories = categories
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

  # should be able to target categories
  def parse_targets targets
    targets.map do |target|
      case target.to_s
      when 'all'
        :all
      when /^@(s+)/ # a category       
        category = target.gsub(/^@/, '').to_sym
        categories.category_of_subject(category) # get models referenced by category
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
