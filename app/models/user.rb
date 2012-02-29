# Provides basic information about a user, including its relationships,
# subscriptions, and feed.
#
# Authors:: Tyler Rigsby, Brett Webber, David Mailhot
class User < ActiveRecord::Base
  attr_accessible :username, :first_name, :last_name, :facebook_id,
                  :age, :like_count, :active

  has_many :posts, :dependent => :destroy, :order => "created_at DESC"

  # links users to the subscriptions table via subscriber id for their
  # subscriptions and via subscribed id to determine their subscribers
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


  # This makes people searchable and tells solr what fields to index
  # searchable do
  #   text :first_name, :last_name, :username
  # end
  
  def self.search(search)
    if search
      @users = find(:all, :conditions => ['upper(first_name) LIKE upper(?) OR upper(last_name) LIKE upper(?) OR upper(username) LIKE upper(?)', "%#{search}%", "%#{search}%", "%#{search}%"])
    else
      find(:all)
    end
  end


  # Sets other values in table to 0.
  def init
    self.like_count ||= 0
  end

  # Creates a new user based on the authentication information given. Users
  # are initialized with a Facebook ID, a first name, a last name, and a
  # username (the same as the Facebook nickname).
  # 
  # Author:: Melissa Winstanley
  def self.create_with_omniauth(auth)
    create! do |user|
      user.facebook_id = auth["uid"]
      user.first_name = auth["info"]["first_name"]
      user.last_name = auth["info"]["last_name"]
      user.username = auth["info"]["nickname"]
    end
  end

  # Subscribes a user to the user specified with subscribe_to
  def subscribe! (subscribe_to)
    self.subscriptions.create!(:subscribed_id => subscribe_to.id)
  end

  # Returns true if this user is subscribing to the 'other' user.
  def subscribing? (other)
    self.subscriptions.find_by_subscribed_id(other.id)
  end

  # Unsubscribes this user from the 'other' user. No effect if the
  # user is not currently subscribed to the other one.
  def unsubscribe! (other)
    self.subscriptions.find_by_subscribed_id(other.id).destroy
  end

  # Returns an array representing a user's feed. 
  def feed
    Post.get_subscribed_posts(self)
  end

  def like!
    self.like_count = self.like_count + 1
    self.save
  end
  
  def self.top
    User.find_by_sql("SELECT u.* FROM users u ORDER BY like_count DESC LIMIT 5")
  end

end
