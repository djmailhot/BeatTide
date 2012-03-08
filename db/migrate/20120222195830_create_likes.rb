# This table "likes", created by this class keeps track of the amount of likes
# that each User has on each Post
#
# Author: Melissa Winstanley
class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.integer :user_id
      t.integer :post_id

      t.timestamps
    end

    add_index :likes, :post_id
  end
end
