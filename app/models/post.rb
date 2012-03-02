# Represents the model for posts, including information about the
# user, song, and likes in a post.
#
# Author:: David Mailhot, Alex Miller, Melissa Winstanley
class Post < ActiveRecord::Base
  attr_accessible :like_count, :created_at

  has_many :likes, :dependent => :destroy

  # there is a many to one relationship between posts and songs
  belongs_to :song
  belongs_to :user

  validates :song_id, :presence => true,
                      :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }
  validates :user_id, :presence => true,
                      :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }

  default_scope :order => 'posts.created_at DESC'

  # Accepts a liking user and updates the post's numbers of likes, the song's
  # number of likes, and the user's number of likes, all increasing by 1. Adds
  # a new like to the database. If the given user already likes this post,
  # nothing is changed.
  def like!(liking_user)
    if !liked_by?(liking_user)
      self.like_count = self.like_count + 1
      song.like!
      self.user.like!
      self.likes.create!(:user_id => liking_user.id, :post_id => self.id)
      self.save
    end
  end

  # Accepts a liking user and updates the post's numbers of likes, the song's
  # number of likes, and the user's number of likes, all decreasing by 1.
  # Deletes the corresponding like from the database. If the given user
  # doesn't like this post, nothing is changed.
  def unlike!(liking_user)
    this_like = Like.find(:all, :conditions => { :user_id => liking_user.id, :post_id => self.id } )
    if (!this_like.nil?)
      self.like_count = self.like_count - 1
      self.likes.delete(this_like)
      song.unlike!
      self.user.unlike!
      self.save
    end
  end

  # Returns true if the passed user likes the post.
  def liked_by?(liking_user)
    new_like = Like.new(:user_id => liking_user.id, :post_id => self.id)
    !new_like.valid?
  end

  # Returns an array of posts from users that the passed user subscribes to.
  def self.get_subscribed_posts(user)
    subscribing_ids = %(SELECT subscribed_id FROM subscriptions
                        WHERE subscriber_id = :user_id)
    where("user_id IN (#{subscribing_ids})",
          :user_id => user)
  end

  # Creates a new post with the passed song a user, and saves the post in the
  # database.
  def self.create_from_song(song, user)
    create! do |post|
      post.song = song
      post.user = user
      post.like_count = 0
    end
  end
end
