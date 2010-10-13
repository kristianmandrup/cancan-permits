class Comment
  include Mongoid::Document
  
  field :user_id, :type => String

  def initialize user_id
    self.user_id = user_id
  end
end

class Post
  include Mongoid::Document
  
  field :writer, :type => String

  def initialize user_id
    self.writer = user_id
  end
end

class Article
  include Mongoid::Document
  
  field :author, :type => String
  
  def initialize name
    self.author = name
  end
end
