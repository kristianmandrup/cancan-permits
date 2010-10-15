require 'mongoid/spec_helper'

Permits::Ability.orm = :mongoid

describe Permits::Ability do
  context "Editor user" do
    context "using default :user_id relation - foreign key to User.id" do   
      before :each do                  
        @editor         = User.create(:name => "Kristian", :role => "editor")
        @other_guy      = User.create(:name => "Random dude", :role => "admin")

        @ability        = Permits::Ability.new(@editor)

        @own_comment    = Comment.create(:user_id => @editor.id)
        @other_comment  = Comment.create(:user_id => @other_guy.id)      
        # @post     = Post.create(:writer => @editor.id)
        # @article  = Article.create(:author => @editor.id)
      end      
      
      it "should be able to :read Comment he owns" do
        @ability.should be_able_to(:read, Comment)
        @ability.should be_able_to(:read, @own_comment)      
      end

      it "should be able to :update Comment he owns" do
        @ability.should be_able_to(:update, @own_comment)      
      end

      it "should NOT be able to :update Comment he does NOT own" do
        @ability.should_not be_able_to(:update, @other_comment)      
      end
      
      it "should be able to :delete Comment he owns" do
        @ability.should be_able_to(:delete, @own_comment)      
      end
      
      it "should NOT be able to :update Comment he does NOT own" do
        @ability.should_not be_able_to(:delete, @other_comment)      
      end
    end 
    
    context "using custom :writer relation - foreign key to User.id" do   
      before :each do                  
        @editor         = User.create(:name => "Kristian", :role => "editor")
        @other_guy      = User.create(:name => "Random dude", :role => "admin")

        @ability        = Permits::Ability.new(@editor)

        @own_post       = Post.create(:writer => @editor.id)
        @other_post     = Post.create(:writer => @other_guy.id)      
      end      
      
      it "should be able to :read Post he owns" do
        @ability.should be_able_to(:read, Post)
        @ability.should be_able_to(:read, @own_post)      
      end

      it "should be able to :update Post he owns" do
        @ability.should be_able_to(:update, @own_post)      
      end

      it "should NOT be able to :update Post he does NOT own" do
        @ability.should_not be_able_to(:update, @other_post)      
      end
      
      it "should be able to :delete Post he owns" do
        @ability.should be_able_to(:delete, @own_post)      
      end
      
      it "should NOT be able to :update Post he does NOT own" do
        @ability.should_not be_able_to(:delete, @other_post)      
      end
    end    
  end        
end