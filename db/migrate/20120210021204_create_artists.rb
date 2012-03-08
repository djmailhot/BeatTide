# The table "artists", created by this class contains a artist's metadata, such as
# its title and its id in the used api.
#
# Author: Brett Webber
class CreateArtists < ActiveRecord::Migration
  def change
    create_table :artists do |t|
      t.string :title
      t.integer :api_id
      t.timestamps
    end
    add_index :artists, :api_id
  end
end
