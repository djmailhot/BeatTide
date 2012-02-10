class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :first_name
      t.string :last_name
      t.int :facebook_id
      t.int :age
      t.int :likes
      t.boolean :active

      t.timestamps
    end
  end
end
