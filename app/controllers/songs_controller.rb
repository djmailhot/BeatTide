# Manages all actions corresponding to modifying to the Song, Artist, and Album models.
#
# Author:: Brett Webber
class SongsController < ApplicationController
  before_filter :authenticate

  # Sets the global songs to be all of the Songs in the database 
  def index
    @songs = Song.all
    @title = "All songs"
  end

  # Initializes a new Song, Artist, and Album without saving or intializing fields
  def new
    @song = Song.new
    @album = Album.new
    @artist = Artist.new
    @title = "New Song"    
  end

  # Shows the fields of the song according to the format
  def show
    @song = Song.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @song }
    end    
  end
end
