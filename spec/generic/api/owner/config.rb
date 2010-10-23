def owner_config context
  send :"#{context}_config"
end

def editor_config
  puts "editor config"
  
  @editor   = User.new(1, :editor, 'kristian')
  @ability  = Permits::Ability.new @editor
  @own_comment  = Comment.new(1)
  @other_comment  = Comment.new(2)
  @post     = Post.new(1)
  @article  = Article.new('kristian')      
end

def two_users_config 
  @editor         = User.new(1, :editor, "kristian")
  @other_guy      = User.new(1, :admin, "other")

  @ability        = Permits::Ability.new @editor

  @own_post       = Post.new(1)
  @other_post     = Post.new(2)      
end

