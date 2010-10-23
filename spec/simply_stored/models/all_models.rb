class Comment
  include SimplyStored::Couch
  
  property :user_id, :type => String 
end

class Post
  include SimplyStored::Couch
  
  property :writer, :type => String
end

class Article
  include SimplyStored::Couch
  
  property :author, :type => String  
end
