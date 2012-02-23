class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.string :name
      t.integer :api_id
      t.timestamps
      
    end
  end
end
