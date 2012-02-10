class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.int :api_id
      t.int :likes
      t.string :title
      t.int :album_id
      t.int :artist_id

      t.timestamps
    end
  end
end
