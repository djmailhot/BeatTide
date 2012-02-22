# Represents the model for posts, including information about the
# user, song, and likes in a post.
# Author::David Mailhot
class Post < ActiveRecord::Base

attr_accessible :likes

belongs_to :user
belongs_to :song

end