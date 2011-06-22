def basic_config context
  send :"#{context}_config"
end

def guest_config
  @guest    = User.new(1, :guest)
  @ability  = Permits::Ability.new @guest 
  @comment  = Comment.new(1)
  @post     = Post.new(1)
end

def admin_config
  @admin = User.new(1, :admin, 'kristian')
  @ability = Permits::Ability.new(@admin)
end

def admin_account_config
  @user = User.new(1, :admin, 'kristian')
  @admin = AdminAccount.new(:user_id => @admin.id, :role => 'admin')
  @ability = Permits::Ability.new(@account)
end
