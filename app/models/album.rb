# An Album holds the name of an Album, and is associated with one or many Songs
#
# Author:: Brett Webber, Alex Miller
class Album < ActiveRecord::Base
  attr_accessible nil

  validates :title, :presence => true,
                    :length => { :minimum => 1, :maximum => Song::MAX_LENGTH }
  validates :api_id, :presence => true,
                     :uniqueness => true,
                     :numericality => { :only_integer => true,
                                        :greater_than_or_equal_to => 0 }

  has_many :songs

  # Searches for a album with the passed album API id. If no album is found, creates
  # a new album. Returns the album. The album that is returned is always guaranteed
  # to be in the database.
  def self.find_or_create(api_id, title)
    album = Album.find_by_api_id(api_id)
    if album.nil?
      album = create! do |album|
        album.api_id = api_id
        album.title = Utility.check_length_or_truncate(title, Song::MAX_LENGTH)
      end
      logger.info "Album :: New album saved to database
                   #{album.attributes.inspect}"
    end
    album
  end
end
