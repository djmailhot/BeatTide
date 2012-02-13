# Posts are associated with users.  Through this relationship, the following
# methods are exposed:
# * post.user
# * user.posts
# * user.posts.create(arg)  - create a new post (user_id = user.id)
# * user.posts.create!(arg) - create a new post, exception on fail
# * user.posts.build(arg)   - return a new post (user_id = user.id)

class Post < ActiveRecord::Base

  attr_accessible :song_id, :likes, :user_id

  belongs_to :user

  validates :user_id, presence: true
  validates :song_id, presence: true
  validates :likes, numericality: { only_integer: true, 
                                    greater_than_or_equal_to: 0 }

  # default ordering of posts is by creation date
  default_scope order: 'posts.created_at DESC'

  # Initialize posts with a default number of likes
  after_initialize :init

  def init
    self.likes ||= 0
  end


end
