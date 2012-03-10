# Represents a user's "like" of another user's post. User and post
# IDs must be non-negative integers.
#
# Author:: Melissa Winstanley
class Like < ActiveRecord::Base

  attr_accessible :user_id, :post_id

  # Must have a unique pair of (user, post)
  validates_uniqueness_of :user_id, :scope => :post_id

  # validations for user and post IDs
  validates :user_id, :presence => true,
                      :numericality => { :only_integer => true,
                                         :greater_than_or_equal_to => 0 }
  validates :post_id, :presence => true,
                      :numericality => { :only_integer => true,
                                         :greater_than_or_equal_to => 0 }

  # Create a new post, setting the user ID and post ID to the given
  # values.
  def self.create_new(user_id, post_id)
    new do |like|
      like.user_id = user_id
      like.post_id = post_id
    end
  end
end
