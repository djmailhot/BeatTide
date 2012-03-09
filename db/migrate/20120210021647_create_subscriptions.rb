# The table "subscriptions", created by this class keeps track of the user ids
# of each of the subscribers and subscribed users
#
# Author: Melissa Winstanley, David Mailhot, Tyler Rigsby
class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :subscriber_id
      t.integer :subscribed_id

      t.timestamps
    end

    add_index :subscriptions, :subscriber_id
    add_index :subscriptions, :subscribed_id
    add_index :subscriptions, [:subscriber_id, :subscribed_id], :unique => true
  end
end
