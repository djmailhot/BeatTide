class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.int :subscriber_id
      t.int :subscribed_id

      t.timestamps
    end
  end
end
