# An Artist holds the name of an Artist, and is associated with one or
# many Songs. Its title must be non-nil, non-empty, and shorter than 200
# characters, and its API ID must be a non-negative integer.
#
# Author:: Brett Webber, Alex Miller, Melissa Winstanley
class Artist < ActiveRecord::Base

  # No attributes can be mass-assigned
  attr_accessible nil

  # validation of API ID and title
  validates :title, :presence => true,
                    :length => { :minimum => 1,
                                 :maximum => Utility::MAX_LENGTH }
  validates :api_id, :presence => true,
                     :uniqueness => true,
                     :numericality => { :only_integer => true,
                                        :greater_than_or_equal_to => 0 }

  # there is a many-to-one relationship between songs and artists
  has_many :songs

  # Searches for a artist with the passed artist API id. If no artist is found, creates
  # a new artist. Returns the artist. The artist that is returned is always guaranteed
  # to be in the database. If the provided API ID is invalid (nil, negative,
  # not-integer) or the provided title is invalid (nil, empty), then returns nil.
  # Title is truncated to 200 characters in length.
  def self.find_or_create(api_id, title)
    artist = Artist.find_by_api_id(api_id)
    if artist.nil?
      artist = Artist.new
      artist.api_id = api_id
      artist.title = Utility.check_length_or_truncate(title, Utility::MAX_LENGTH)
      if artist.valid?
        artist.save
        logger.info "Album :: New artist saved to database
                     #{artist.attributes.inspect}"
      else
        artist = nil
      end
    end
    artist
  end
end
