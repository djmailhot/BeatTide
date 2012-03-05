# Represents a user's "like" of another user's post.
#
# Author:: Melissa Winstanley
class Like < ActiveRecord::Base
  attr_accessible :user_id, :post_id

  validates_uniqueness_of :user_id, :scope => :post_id

  def self.create_new(user_id, post_id)
    new do |like|
      like.user_id = user_id
      like.post_id = post_id
    end
  end
end
