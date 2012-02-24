# Represents the model for posts, including information about the
# user, song, and likes in a post.
# Author::David Mailhot
class Post < ActiveRecord::Base

attr_accessible :likes

belongs_to :user

# there is a many to one relationship between posts and songs
belongs_to :song

def self.create_from_song(song, user)
  create! do |post|
    post.song = song
    post.user = user
    post.likes = 0
  end
end

end
