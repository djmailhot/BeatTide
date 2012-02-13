# This class represents a subscription from one
# user to another. When a user 'subscribes' to
# another user, a new Subscription should be
# created, with the subscribing user's id as
# 'subscriber_id' and the user they are subscribing
# to as the 'subscribed_id'.
#
# Author:: Tyler Rigsby (mailto: rigsbyt@cs.uw.edu)
class Subscription < ActiveRecord::Base
  
  # The subscribed id should be accessible, because
  # the subscribing user should control who they
  # subscribe to, but not who is subscribing.
  attr_accessible :subscribed_id
  
  # A subscription belongs to both a subscriber
  # and the subscribed
  belongs_to :subscriber, :class_name => "User"
  belongs_to :subscribed, :class_name => "User"
  
  # A subscription is only valid if it contains both
  # the subscriber and subscribed, and they are different.
  validates :subscriber, :presence => true
  validates :subscribed, :presence => true
  validates :subscriber, :exclusion => { :in => %w(:subscribed) }

end
