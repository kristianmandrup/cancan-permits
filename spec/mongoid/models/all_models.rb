class Comment
  include Mongoid::Document
  
  field :user_id, :type => String
end

class Post
  include Mongoid::Document
  
  field :writer, :type => String
end

class Article
  include Mongoid::Document
  
  field :author, :type => String  
end
