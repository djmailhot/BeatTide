# A Song holds the metadata for a particular Song, as well as the
# number of people that like it. Its title must be non-nil,
# non-empty, and shorter than 200 characters, and its API ID must
# be a non-negative integer.
#
# Author:: Brett Webber, Alex Miller, Melissa Winstanley
class Song < ActiveRecord::Base

  # No attributes can be mass-assigned
  attr_accessible nil

  # Links to Album and Artist models are defined
  belongs_to :album
  belongs_to :artist

  # there is a many-to-one relationship between posts and songs
  has_many :posts

  # validation of api_id and title
  validates :api_id, :presence => true,
                     :uniqueness => true,
                     :numericality => { :only_integer => true,
                                        :greater_than_or_equal_to => 0 }
  validates :title, :presence => true,
                    :length => { :minimum => 1,
                                 :maximum => Utility::MAX_LENGTH }

  after_initialize :init

  # Adds one to the likes of this Song.
  def like!
    self.like_count = self.like_count + 1
    self.save
    logger.debug "Song :: #{self.title} liked."
  end

  # Subtracts one from the likes of this Song. If likes are 0, does nothing.
  def unlike!
    if self.like_count != 0
      self.like_count = self.like_count - 1
      self.save
      logger.debug "Song :: #{self.title} unliked."
    end
  end

  # Searches for a song with the passed song API id. If no song is found, creates
  # a new song. Returns the song. The song that is returned is always guaranteed
  # to be in the database. If the provided API IDs are invalid (nil, negative,
  # not-integer) or the provided titles are invalid (nil, empty), then returns
  # nil. Titles are truncated to 200 characters in length.
  def self.find_or_create(song_api_id, song_title, album_api_id, album_title,
                          artist_api_id, artist_title)
    song = Song.find_by_api_id(song_api_id)
    if song.nil?
      song = Song.new
      song.api_id = song_api_id
      song.title = Utility.check_length_or_truncate(song_title,
                                                    Utility::MAX_LENGTH)
      song.like_count = 0
      song.album = Album.find_or_create(album_api_id, album_title)
      song.artist = Artist.find_or_create(artist_api_id, artist_title)
      if song.valid?
        song.save
        logger.info "Song :: New song in database #{song.attributes.inspect}"
      else
        song = nil
      end
    end
    song
  end

  # Returns the top 5 songs by like count. Only includes songs with positive
  # likes.
  def self.top
    Song.find_by_sql(
      "SELECT s.* FROM songs s WHERE like_count > 0 ORDER BY like_count DESC LIMIT 5")
  end

  private
    # Ensure that the number of likes is never set to nil.
    def init
      self.like_count = 0 if self.like_count.nil?
    end

end
