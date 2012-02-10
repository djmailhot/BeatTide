class Subscription < ActiveRecord::Base

attr_accessible :subscribed_id

belongs_to :subscriber, :class_name => "User"
belongs_to :subscribed, :class_name => "User"

validates :subscribed, presence => true
validates :subscribed, presence => true

end
