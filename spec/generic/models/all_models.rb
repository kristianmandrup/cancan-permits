

class Comment
  attr_accessor :user_id

  def initialize user_id
    self.user_id = user_id
  end
end

class Post
  attr_accessor :writer  

  def initialize user_id
    self.writer = user_id
  end
end

class Article
  attr_accessor :author
  
  def initialize name
    self.author = name
  end
end
