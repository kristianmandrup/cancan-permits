class Comment
  include MongoMapper::Document
  
  key :user_id, String
end

class Post
  include MongoMapper::Document
  
  key :writer, String
end

class Article
  include MongoMapper::Document
  
  key :author, String  
end
