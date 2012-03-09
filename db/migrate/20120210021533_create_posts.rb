# The table "posts", created by this class keeps track of the ids of the user
# who owns the post and the song that the post contains.  It also includes how
# many likes the post has gotten.
#
# Author: Tyler Rigsby
class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :user_id
      t.integer :song_id
      t.integer :like_count

      t.timestamps
    end
    # Make a multiple key index on user id and creation time.
    # Better performance when retreiving posts sorted on creation time.
    add_index :posts, [:user_id, :created_at]
  end
end
