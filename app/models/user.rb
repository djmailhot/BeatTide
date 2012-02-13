class User < ActiveRecord::Base
  attr_accessible :username, :first_name, :last_name, :facebook_id,
                  :age, :likes, :active

  has_many :posts, :dependent => :destroy

  has_many :subscriptions, :foreign_key => "subscriber_id",
                           :dependent => :destroy
  has_many :reverse_subscriptions, :dependent => :destroy,
                                   :foreign_key => "subscribed_id",
                                   :class_name => "Subscription"

  # To access a User object's subscribed-to-user list, access User.subscribing
  has_many :subscribing, :through => :subscriptions,
                         :source => :subscribed
  has_many :subscribers, :through => :reverse_subscriptions,
                         :source => :subscriber


  validates :facebook_id, :presence => true,
                          :uniqueness => true
  validates :username, :presence => true
  validates :first_name, :presence => true
  validates :last_name, :presence => true

  after_initialize :init

  def init
    self.likes ||= 0
  end

  def self.create_with_omniauth(auth)
    create! do |user|
      user.facebook_id = auth["uid"]
      user.first_name = auth["info"]["first_name"]
      user.last_name = auth["info"]["last_name"]
      user.username = auth["info"]["nickname"]
    end
  end

  def subscribe! (subscribe_to)
    self.subscriptions.create!(:subscribed_id => subscribe_to.id)
  end

  def subscribing? (other)
    self.subscriptions.find_by_subscribed_id(other.id)
  end

  def unsubscribe! (other)
    self.subscriptions.find_by_subscribed_id(other.id).destroy
  end

  def feed
    # Post.feed_for self
    []
  end

end
