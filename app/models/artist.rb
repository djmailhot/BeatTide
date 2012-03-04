# An Artist holds the name of an Artist, and is associated with one or many Songs
#
# Author:: Brett Webber, Alex Miller
class Artist < ActiveRecord::Base
  attr_accessible :title, :api_id

  validates :title, :presence => true,
                    :length => { :minimum => 1, :maximum => 200 }
  validates :api_id, :presence => true,
                     :uniqueness => true,
                     :numericality => { :only_integer => true,
                                        :greater_than_or_equal_to => 0 }

  has_many :songs

  # Searches for a artist with the passed artist API id. If no artist is found, creates
  # a new artist. Returns the artist. The artist that is returned is always guaranteed
  # to be in the database.
  def self.find_or_create(api_id, title)
    artist = Artist.find_by_api_id(api_id)
    if artist.nil?
      artist = create! do |artist|
        artist.api_id = api_id
        artist.title = title
      end
      logger.info "Album :: New artist saved to database
                   #{artist.attributes.inspect}"
    end
    artist
  end
end
