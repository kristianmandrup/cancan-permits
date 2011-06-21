module Permits
  class Configuration
    class Permissions
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
        build_statements :can, &block
      end

      def cannot_eval &block
        build_statements :cannot, &block
      end

      # build the 'can' or 'cannot' statements to evaluate
      def build_statements method, &block
        return nil if !send(method)
        statements = [:manage, :read, :update, :create, :write].map do |action|
          # same as calling: can[action] or cannot[action]
          targets = send(method).send(:[], action.to_s)
          targets ? "#{method}(:#{action}, #{parse_targets(targets)})" : nil
        end.compact.join("\n")
        yield statements if !statements.empty? && block
      end

      # parse the value of a Permission
      def parse_targets targets
        targets.map do |target|
          case target.to_s
          when 'all'
            :all
          when /^@(s+)/ # a category is prefixed with a '@'
            # remove the '@' prefix to get the category name
            category = target.gsub(/^@/, '').to_sym 

            # look up the category and get models referenced by said category
            categories.category_of_subject(category) 
          else
            begin
              target
            rescue
              puts "[permission] target #{target} does not have a class so it was skipped"
            end
          end
        end
      end
    end
  end
end
