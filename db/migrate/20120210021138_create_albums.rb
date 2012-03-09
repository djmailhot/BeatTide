# The table "albums", created by this class contains a album's metadata, such as
# its title and its id in the used api.
#
# Author: Brett Webber
class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.string :title
      t.integer :api_id
      t.timestamps
    end
    add_index :albums, :api_id, :unique => true
  end
end
