require 'active_record/spec_helper'

describe Permits::Ability do
  context "Guest user" do
    before :each do
      @guest    = User.create(:name => "Kristian", :role => "guest")

      @ability  = Permits::Ability.new(@guest)

      @comment  = Comment.create(:user_id => @guest.id)

      @post     = Post.create(:writer => @guest.id)

      @article  = Article.create(:author => @guest.id)
    end

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
end