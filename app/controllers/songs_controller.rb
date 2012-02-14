class SongsController < ApplicationController

  def index
    @songs = Song.all
    @title = "All songs"
  end

  def new
    @song = Song.new
    @title = "New Song"    
  end

  def create
    @song = Song.new(params[:song])
    @song.save    
  end

  def show
    @song = Song.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @song }
    end    
  end

  def edit
    @song = Song.find(params[:id])    
  end
end
