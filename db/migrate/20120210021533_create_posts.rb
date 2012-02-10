class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.int :user_id
      t.int :song_id
      t.int :likes

      t.timestamps
    end
  end
end
