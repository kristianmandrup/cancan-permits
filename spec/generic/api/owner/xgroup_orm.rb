require 'generic/api/owner/xgroup'

def two_users_config 
  @editor         = User.create(:name => "Kristian", :role => "editor")
  @other_guy      = User.create(:name => "Random dude", :role => "admin")

  @ability        = Permits::Ability.new(@editor)

  @own_post       = Post.create(:writer => @editor.id)
  @other_post     = Post.create(:writer => @other_guy.id)      
end

def editor_config
  @editor         = User.create(:name => "Kristian", :role => "editor")
  @other_guy      = User.create(:name => "Random dude", :role => "admin")

  @ability        = Permits::Ability.new(@editor)

  @own_comment    = Comment.create(:user_id => @editor.id)
  @other_comment  = Comment.create(:user_id => @other_guy.id)      
  # @post     = Post.create(:writer => @editor.id)
  # @article  = Article.create(:author => @editor.id)
end  
