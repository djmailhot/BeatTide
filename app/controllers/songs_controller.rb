# Manages all actions corresponding to modifying to the Song, Artist, and Album models.
#
# Author: Brett Webber
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

  # Initializes and saves a new Song with the Song information passed through params.  Checks to see if the Album and Artist of the Song
  # already exist, and uses references to those if they do.  Otherwise, creates new Album and Artist entries corresponding to their names in
  # The global params array.
  def create
    @song = Song.new(params[:song])
    @album = Album.find_by_name(params[:album][:name])
    if (@album.nil?)
      @album = Album.new(params[:album])
      @album.save
    end
    @artist = Artist.find_by_name(params[:artist][:name])
    if (@artist.nil?)
      @artist = Artist.new(params[:artist])
      @artist.save
    end
    @song.album = @album
    @song.artist = @artist
    @song.save
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
