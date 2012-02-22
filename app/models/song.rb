# A Song holds the metadata for a particular Song, as well as a tracking of the amount of people that like it
#
# Author:: Brett Webber, Alex Miller
class Song < ActiveRecord::Base
  attr_accessible :api_id, :likes, :title # id corresponding to api, # of likes, and title of song respectively
  
  # Links to Album and Artist models are defined
  belongs_to :album
  belongs_to :artist

  # there is a many to one relationship between posts and songs
  has_many :post

  # validation of api_id and title
  validates :api_id, :presence => true,
                     :uniqueness => true
  validates :title, :presence => true

  after_initialize :init
  
  # Starts off the Song's likes at 0 if uninitialized after creation
  def init
    self.likes ||= 0
  end

  # Adds one to the likes of this Song
  def like
    self.likes = self.likes + 1
  end
  
  # Creates a song object, but does not save it to the database. This is useful
  # if you want to transform Grooveshark metadata into a song object to display
  # it in a view, but you don't want to save the song to the database yet.
  def self.create_temporary(metadata)
    song = Song.new
    song.api_id = metadata["SongID"]
    album = Album.find_by_name(metadata["SongID"])
    if (album.nil?)
      album = Album.new
      album.name = metadata["AlbumName"]
    end
    artist = Artist.find_by_name(metadata["AlbumName"])
    if (artist.nil?)
      artist = Artist.new
      artist.name = metadata["ArtistName"]
    end
    song.album = album
    song.artist = artist
    song
  end
end