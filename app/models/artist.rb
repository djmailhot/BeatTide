# An Artist holds the name of an Artist, and is associated with one or many Songs
class Artist < ActiveRecord::Base
  attr_accessible :name

  has_many :songs
end
