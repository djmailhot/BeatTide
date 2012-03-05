# A Song holds the metadata for a particular Song, as well as a tracking of the amount of people that like it
#
# Author:: Brett Webber, Alex Miller, Melissa Winstanley
class Song < ActiveRecord::Base
  attr_accessible nil

  # Links to Album and Artist models are defined
  belongs_to :album
  belongs_to :artist

  # there is a many to one relationship between posts and songs
  has_many :posts

  # validation of api_id and title
  validates :api_id, :presence => true, :uniqueness => true
  validates :title, :presence => true

  # Adds one to the likes of this Song
  def like!
    self.like_count = self.like_count + 1
    self.save
    logger.debug "Song :: #{self.title} liked."
  end

  # Subtracts one from the likes of this Song
  def unlike!
    self.like_count = self.like_count - 1
    self.save
  end

  # Searches for a song with the passed song API id. If no song is found, creates
  # a new song. Returns the song. The song that is returned is always guaranteed
  # to be in the database.
  def self.find_or_create(song_api_id, song_title, album_api_id, album_title,
                          artist_api_id, artist_title)
    song = Song.find_by_api_id(song_api_id)
    if song.nil?
      song = create! do |song|
        song.api_id = song_api_id
        song.title = song_title
        song.album = Album.find_or_create(album_api_id, album_title)
        song.artist = Artist.find_or_create(artist_api_id, artist_title)
      end
      logger.info "Song :: New song in database #{song.attributes.inspect}"
    end
    song
  end
  
  def self.top
    Song.find_by_sql("SELECT s.* FROM songs s ORDER BY like_count DESC LIMIT 5")
  end
end
