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

  # Runs a TinySong search with the passed query, and renders a table of the
  # results. The song ID's which are returned by this request correspond to
  # Grooveshark songs.
  def songs_from_query
    if params[:query]
      query = URI.escape(params[:query])
      url = URI.parse("#{TINY_SONG_API}/s/#{query}?format=json&limit=#{NUM_SEARCH_RESULTS}&key=#{TINY_SONG_API_KEY}")
      response = Net::HTTP.get_response(url).body
      @song_results = ActiveSupport::JSON.decode(response)
      @song_results = @song_results.map do |song|
        Song.create_temporary(song)
      end
      render 'songs/song_list', :layout => false
    else
    render :text => "No query."
    end
  end
end
