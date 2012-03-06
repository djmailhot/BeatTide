# A Song holds the metadata for a particular Song, as well as a tracking of the amount of people that like it
#
# Author:: Brett Webber, Alex Miller, Melissa Winstanley
class Song < ActiveRecord::Base
  MAX_LENGTH = 200

  attr_accessible nil

  # Links to Album and Artist models are defined
  belongs_to :album
  belongs_to :artist

  # there is a many to one relationship between posts and songs
  has_many :posts

  # validation of api_id and title
  validates :api_id, :presence => true,
                     :uniqueness => true,
                     :numericality => { :only_integer => true,
                                        :greater_than_or_equal_to => 0 }
  validates :title, :presence => true,
                    :length => { :minimum => 1, :maximum => MAX_LENGTH }

  after_initialize :init

  def init
    self.like_count = 0 if self.like_count.nil?
  end

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
<<<<<<< HEAD
        song.title = Utility.check_length(song_title, MAX_LENGTH)
=======
        if song_title.length > MAX_LENGTH
          song_title = song_title[0,MAX_LENGTH]
        end
        song.title = song_title
>>>>>>> 0bd733c4ac4f498b0b448d0de0747392d33a5af7
        song.like_count = 0
        song.album = Album.find_or_create(album_api_id, album_title)
        song.artist = Artist.find_or_create(artist_api_id, artist_title)
      end
      logger.info "Song :: New song in database #{song.attributes.inspect}"
    end
    song
  end

  def self.top
    Song.find_by_sql("SELECT s.* FROM songs s WHERE like_count > 0 ORDER BY like_count DESC LIMIT 5")
  end
end
