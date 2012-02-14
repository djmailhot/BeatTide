# An Album holds the name of an Album, and is associated with one or many Songs
class Album < ActiveRecord::Base
  attr_accessible :name

  has_many :songs
end
