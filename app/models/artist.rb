# An Artist holds the name of an Artist, and is associated with one or many Songs
#
# Author: Brett Webber, Alex Miller
class Artist < ActiveRecord::Base
  attr_accessible :name, :api_id

  validates :name, :presence => true
  validates :api_id, :presence => true, :uniqueness => true

  has_many :songs
end
