class Comment < ActiveRecord::Base
  belongs_to :user
end

class Post < ActiveRecord::Base
  belongs_to :user
end

class Article < ActiveRecord::Base
  belongs_to :user
end
