require 'generic/api/basic/xgroup'

# override some key methods to ensure it works with ORM object instantiation
def basic_config context
  send :"#{context}_config"
end

def guest_config  
  @guest   = User.create(:name => "Kristian", :role => "guest")
  @ability  = Permits::Ability.new(@guest)
  @comment  = Comment.create(:user_id => @guest.id)
  @post     = Post.create(:writer => @guest.id)
  @article  = Article.create(:author => @guest.id)
end

def admin_config
  @admin = User.create(:role => 'admin')
  @ability = Permits::Ability.new(@admin)
end

