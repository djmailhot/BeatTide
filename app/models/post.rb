# Represents the model for posts, including information about the
# user, song, and likes in a post.
# Author::David Mailhot
class Post < ActiveRecord::Base
  attr_accessible :like_count
  attr_accessible :likes

  has_many :likes, :dependent => :destroy
  belongs_to :user
  belongs_to :song

  # :posting_user, :grooveshark_hash
  def self.create_new_post(attr)
    create! do |post|
      post.song = Song.get_or_create(attr[:grooveshark_hash])
      post.user = attr[:posting_user]
      post.like_count = 0
    end
  end

  def like(user)
    if !liked_by?(user)
      like_count = like_count + 1
      song.like
      user.like
    end
  end

  def liked_by?(user)
    this_id = self.id
    user_ids = %(SELECT user_id FROM likes
                        WHERE post_id = #{this_id})
    
    result = where("user_id IN (#{user_ids}) AND user_id = :user_id",
                   :user_id => user)
    result.length != 0
  end

  def self.get_subscribed_posts(user)
    # to implement
  end

  # there is a many to one relationship between posts and songs
  belongs_to :song

  # Creates a new post with the passed song a user, and saves the post in the
  # database.
  def self.create_from_song(song, user)
    create! do |post|
      post.song = song
      post.user = user
      post.likes = 0
    end
  end
end
