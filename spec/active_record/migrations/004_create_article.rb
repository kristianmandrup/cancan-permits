class CreateArticle < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.integer   :author
      t.string    :body      
      t.timestamps
    end
  end

  def self.down
    drop_table :comments
  end
end
