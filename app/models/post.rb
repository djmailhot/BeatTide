# Represents the model for posts, including information about the
# user, song, and likes in a post.
# Author::David Mailhot
class Post < ActiveRecord::Base
  attr_accessible :like_count

  has_many :likes, :dependent => :destroy

  # there is a many to one relationship between posts and songs
  belongs_to :song
  belongs_to :user

  default_scope :order => 'posts.created_at DESC'

  def like!(liking_user)
    if !liked_by?(liking_user)
      self.like_count = self.like_count + 1
      song.like!
      self.user.like!
      self.likes.create!(:user_id => liking_user.id, :post_id => self.id)
      self.save
    end
  end

  def liked_by?(liking_user)
    new_like = Like.new(:user_id => liking_user.id, :post_id => self.id)
    !new_like.valid?
  end

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
