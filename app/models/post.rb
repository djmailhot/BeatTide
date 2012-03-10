# Represents the model for posts, including information about the
# user, song, and likes in a post.
#
# Author:: David Mailhot, Alex Miller, Melissa Winstanley
class Post < ActiveRecord::Base

  # No attributes can be mass-assigned
  attr_accessible nil

  # there is a many-to-one relationship between likes and posts
  has_many :likes, :dependent => :destroy

  # there is a many to one relationship between posts and songs
  belongs_to :song
  belongs_to :user

  # validation of song ID and user ID
  validates :song_id, :presence => true,
                      :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }
  validates :user_id, :presence => true,
                      :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }

  # Set up ordering of posts
  default_scope :order => 'posts.created_at DESC'

  after_initialize :init

  # Accepts a liking user and updates the post's numbers of likes, the song's
  # number of likes, and the user's number of likes, all increasing by 1. Adds
  # a new like to the database. If the given user already likes this post,
  # nothing is changed. If the liking user is the same user who posted this
  # post, then the user's likes are not increased.
  def like!(liking_user)
    if check_user(liking_user) && !liked_by?(liking_user)
      logger.info "Post :: User #{liking_user.username} liked post #{self.id}."
      self.like_count = self.like_count + 1
      self.likes.create!(:user_id => liking_user.id, :post_id => self.id)
      song.like!

      if self.user != liking_user
        self.user.like!
        logger.info "Post :: User #{liking_user.username} liked their own post."
      end
      self.save
      logger.debug "Post :: User #{liking_user.username} liked post " <<
                   "#{self.attributes.inspect}"
    end
  end

  # Accepts a liking user and updates the post's numbers of likes, the song's
  # number of likes, and the user's number of likes, all decreasing by 1.
  # Deletes the corresponding like from the database. If the given user
  # doesn't like this post, nothing is changed. If the liking user is the
  # same user who posted this post, then the user's like are not changed.
  def unlike!(liking_user)
    this_like = Like.find(:all, :conditions => { :user_id => liking_user.id,
                                                 :post_id => self.id } )
    if (!this_like.nil?)
      if (liking_user.id != self.id)
        self.like_count = self.like_count - 1
        self.likes.delete(this_like)
      end
      song.unlike!
      self.user.unlike!
      self.save
    end
  end

  # Returns true if the passed user likes the post. Returns false
  # otherwise, or if the liking user or its user ID are nil.
  def liked_by?(liking_user)
    if check_user(liking_user)
      new_like = Like.new(:user_id => liking_user.id, :post_id => self.id)
      !new_like.valid?
    else
      false
    end
  end

  # Returns an array of posts from users that the passed user subscribes to.
  # If the passed user is nil or its user ID is nil, returns an empty array.
  def self.get_subscribed_posts(user)
    if !user.nil? && !user.id.nil?
      subscribing_ids = %(SELECT subscribed_id FROM subscriptions
                          WHERE subscriber_id = :user_id)
      where("user_id IN (#{subscribing_ids})", :user_id => user)
    else
      []
    end
  end

  # Creates a new post with the passed song and user, and saves the post in
  # the database. Raises a RecordInvalid exception if the provided song and
  # post are not valid a valid song or post. Sets likes to 0.
  def self.create_from_song(song, user)
    create! do |post|
      post.song = song
      post.user = user
      post.like_count = 0
      logger.info "Post :: New post saved to database #{post.attributes.inspect}"
    end
  end

  private
    # Ensure that the number of likes is never set to nil.
    def init
      self.like_count = 0 if self.like_count.nil?
    end

    # Returns whether the given user is valid (ie is not nil and has a non-nil
    # user ID).
    def check_user(user)
      !user.nil? && !user.id.nil?
    end

end
