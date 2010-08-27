module RolePermit
  class Guest < Base
    def initialize(ability)
      super
    end

    def permit?(user, request=nil) 
      super
      return if !role_match? user
      
      can :read, [Comment, Post]
      can [:update, :destroy], [Comment]
      can :create, Article
      
      # owns(user, Comment)
      
      # a user can manage comments he/she created
      # can :manage, Comment do |comment|
      #   comment.try(:user) == user
      # end            
      
      # can :create, Comment
    end  
  end
end