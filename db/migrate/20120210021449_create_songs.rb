# The table "songs", created by this class contains a song's metadata, such as
# its title, links to its album and artist, the amount of overall likes that
# the song has, as well as its id in the used api.
#
# Author: Brett Webber
class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.integer :api_id # the id of the song in the external api used to play songs
      t.integer :like_count
      t.string :title
      t.integer :album_id
      t.integer :artist_id

      t.timestamps
    end
    add_index :songs, :api_id, :unique => true
    add_index :songs, :album_id
    add_index :songs, :artist_id
  end
end
