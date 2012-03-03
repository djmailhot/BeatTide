# Controller for making requests from the Grooveshark API. Allows streaming
# from Grooveshark through the Grooveshark gem.
#
# Author::   Alex Miller, Harnoor Singh
class GroovesharkController < ApplicationController
  
  # Key for TinySong api. This can be hardcoded because it stays good forever.
  TINY_SONG_API_KEY = "d44e54b31d4333b5940119c69fddc429"
  
  # Number of search results to return when user searches for a song.
  NUM_SEARCH_RESULTS = 10
  
  # URL to TinySong API
  TINY_SONG_API = "http://tinysong.com/"
  
  # Renders a song searching interface to the user.
  def search
    # Rails automatically renders the corresponding "search" view.
    render :layout => false
  end
  
  def player
    song_ids = "31548034,7973555"
    render :partial => 'player', :locals => {:song_ids => song_ids}
  end

  # Runs a TinySong search with the passed query, and renders a table of the
  # results. The song ID's which are returned by this request correspond to
  # Grooveshark songs.
  def songs_from_query
    logger.info "Grooveshark :: Query request initiated."
    if params[:query]
      query = URI.escape(params[:query])
      url = URI.parse("#{TINY_SONG_API}/s/#{query}?format=json&limit=#{NUM_SEARCH_RESULTS}&key=#{TINY_SONG_API_KEY}")
      response = Net::HTTP.get_response(url).body
      response_json = ActiveSupport::JSON.decode(response)
      @song_results = response_json.map do |song_json|
        Song.find_or_create(song_json["SongID"], song_json["SongName"],
                            song_json["AlbumID"], song_json["AlbumName"],
                            song_json["ArtistID"], song_json["ArtistName"])
      end
      logger.info "Grooveshark :: query results #{@song_results}."
      render :partial => 'songs/song_list', :locals => {:songs => @song_results}, :layout => false
    else
      render :text => "No query."
    end
  end 
end
