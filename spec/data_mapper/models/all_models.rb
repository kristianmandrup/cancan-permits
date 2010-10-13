class Comment
  include DataMapper::Resource

  property :id, Serial    
  property :user_id, String
end

class Post
  include DataMapper::Resource
  
  property :id, Serial  
  property :writer, String
end

class Article
  include DataMapper::Resource
  
  property :id, Serial  
  property :author, String  
end
