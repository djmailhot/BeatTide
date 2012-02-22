# Represents the model for posts, including information about the
# user, song, and likes in a post.
# Author::David Mailhot
class Post < ActiveRecord::Base

attr_accessible :song, :likes, :user_id

belongs_to :user

end