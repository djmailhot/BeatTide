# The table "users", created by this class contains all of the necessary
# data for a particular user of the site.
#
# Author: Brett Webber, Tyler Rigsby, David Mailhot
class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :first_name
      t.string :last_name
      t.integer :facebook_id
      t.integer :age
      t.integer :like_count
      t.boolean :active

      t.timestamps
    end
    # To make user search faster
    add_index :users, :first_name
    add_index :users, :last_name
    add_index :users, :username
  end  
end
