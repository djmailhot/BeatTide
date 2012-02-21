# A Song holds the metadata for a particular Song, as well as a tracking of the amount of people that like it
#
# Author:: Brett Webber
class Song < ActiveRecord::Base
  attr_accessible :api_id, :likes, :title # id corresponding to api, # of likes, and title of song respectively
  
  # Links to Album and Artist models are defined
  belongs_to :album
  belongs_to :artist

  # validation of api_id and title
  validates :api_id, :presence => true, :uniqueness => true
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
end
