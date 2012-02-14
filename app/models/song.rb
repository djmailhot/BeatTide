# A Song is a model which holds the metadata for a Song 
class Song < ActiveRecord::Base
  attr_accessible :api_id, :likes, :title # id corresponding to api, # of likes, and title of song respectively
  
  # Links to Album and Artist models are defined
  belongs_to :album
  belongs_to :artist

  validates :api_id, :presence => true,
                     :uniqueness => true
  validates :title, :presence => true

  after_initialize :init
  
  # Starts off the Song's likes at 0 if uninitialized after creation
  def init
    self.likes ||= 0
  end

  def like
    self.likes = self.likes + 1
  end
  
end
