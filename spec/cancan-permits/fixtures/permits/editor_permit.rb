module RolePermit
  class Editor < Base
    def initialize(ability)
      super
    end

    def permit?(user, request=nil) 
      super
      return if !role_match? user
     
      # uses default user_id
      owns(user, Comment)     
      # 
      owns(user, Post, :writer)
      # 
      owns(user, Article, :author, :name)

      # a user can manage comments he/she created
      # can :manage, Comment do |comment|
      #   comment.try(:user) == user
      # end            

      # can :create, Comment
    end 
  end
end