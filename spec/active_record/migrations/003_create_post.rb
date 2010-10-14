class CreatePost < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.integer   :writer
      t.string    :body      
      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
