# An Album holds the name of an Album, and is associated with one or many Songs
#
# Author: Brett Webber, Alex Miller
class Album < ActiveRecord::Base
  attr_accessible :title, :api_id
  
  validates :title, :presence => true
  validates :api_id, :presence => true, :uniqueness => true
  
  has_many :songs

  # Searches for a album with the passed album API id. If no album is found, creates
  # a new album. Returns the album. The album that is returned is always guaranteed
  # to be in the database.  
  def self.find_or_create(api_id, title)
    album = Album.find_by_api_id(api_id)
    if album.nil?
      create! do |album|
        album.api_id = api_id
        album.title = title
      end
    end
    album
  end
end
