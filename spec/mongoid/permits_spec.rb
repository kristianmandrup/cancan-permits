require 'mongoid/spec_helper'

# class Comment
#   attr_accessor :owner
# end
# 
# class Post
#   attr_accessor :writer  
# end
# 
# class Article
#   attr_accessor :author
# end

describe Permits::Ability do
  context "Guest user" do
    before :each do
      @guest   = User.create(:name => "Kristian", :role => "guest")

      @ability  = Permits::Ability.new(@guest)

      @comment  = Comment.create(:user_id => @guest.id)

      @post     = Post.create(:writer => @guest.id)

      @article  = Article.create(:author => @guest.id)
    end

    # can :read, [Comment, Post]
    # can [:update, :destroy], [Comment]
    # can :create, Article

    it "should be able to :read Comment and Post but NOT Article" do
      @ability.can?(:read, Comment).should be_true
      @ability.can?(:read, @comment).should be_true
      
      @ability.can?(:read, Post).should be_true      
      @ability.can?(:read, @post).should be_true      
      
      @ability.can?(:read, Article).should be_false
      @ability.can?(:read, @article).should be_false      
    end

    it "should be not able to :update only Comment" do
      @ability.can?(:update, Comment).should be_true
      @ability.can?(:update, @comment).should be_true      
      
      @ability.can?(:update, Post).should be_false
      @ability.can?(:update, @post).should be_false
    end

  end
  
  context "Admin user" do
    before do
      @admin = User.create(:role => 'admin')
      @ability = Permits::Ability.new(@admin)
    end
  # 
  #   # can :manage, :all    
  # 
    it "should be able to :read anything" do
      @ability.can?(:read, Comment).should be_true
      @ability.can?(:read, Post).should be_true      
    end
  
    it "should be not able to :update everything" do
      @ability.can?(:update, Comment).should be_true
      @ability.can?(:update, Post).should be_true
    end
  
    it "should be not able to :create everything" do
      @ability.can?(:create, Comment).should be_true
      @ability.can?(:create, Post).should be_true      
    end
  
    it "should be not able to :update everything" do
      @ability.can?(:destroy, Comment).should be_true
      @ability.can?(:destroy, Post).should be_true
    end
  end
      
end