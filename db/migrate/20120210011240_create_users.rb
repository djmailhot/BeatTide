class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :first_name
      t.string :last_name
      t.integer :facebook_id
      t.integer :age
      t.integer :likes
      t.boolean :active

      t.timestamps
    end
  end
end
