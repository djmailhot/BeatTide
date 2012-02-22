# An Artist holds the name of an Artist, and is associated with one or many Songs
#
# Author: Brett Webber
class Artist < ActiveRecord::Base
  attr_accessible :name

  validates :name, :presence => true

  has_many :songs
end
