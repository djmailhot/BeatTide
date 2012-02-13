class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.integer :api_id
      t.integer :likes
      t.string :title
      t.integer :album_id
      t.integer :artist_id

      t.timestamps
    end
  end
end
