require 'mongoid/spec_helper'

describe Permits::Ability do
  context "Editor user" do
    before :each do
      @editor   = User.new(1, :editor, 'kristian')
      @ability  = Permits::Ability.new @editor
      @comment  = Comment.new(1)
      @post     = Post.new(1)
      @article  = Article.new('kristian')      
    end
   
    it "should be able to :read Comment he owns, using default :user_id relation - foreign key to User.id" do
      @ability.should be_able_to(:read, Comment)
      @ability.should be_able_to(:read, @comment)      
    end

    it "should be able to :read Post he owns, using :owner relation - foreign key to User.id" do
      @ability.should be_able_to(:read, Post)
      @ability.should be_able_to(:read, @post)      
    end
    
    it "should be able to :read Article he owns, using :author relation - foreign key to User.name" do
      @ability.should be_able_to(:read, Article)
      @ability.should be_able_to(:read, @article)
    end 
  end        
end