class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :user_id
      t.integer :song_id
      t.integer :likes

      t.timestamps
    end
    # Make a multiple key index on user id and creation time.
    # Better performance when retreiving posts sorted on creation time.
    add_index :posts, [:user_id, :created_at]
  end
end
