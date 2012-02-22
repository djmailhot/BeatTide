# An Album holds the name of an Album, and is associated with one or many Songs
#
# Author: Brett Webber
class Album < ActiveRecord::Base
  attr_accessible :name

  validates :name, :presence => true

  has_many :songs
end
