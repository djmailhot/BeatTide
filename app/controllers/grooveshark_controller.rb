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
  
  # Gets the stream key for the passed song ID. Renders JSON with the requested
  # stream key. The stream key can be used to play a song through Grooveshark's
  # Flash APIPlayer.
  def song_stream_key
    # grooveshark song id
    song_id = params['query']
    # create a new client with the current session token
    client = Grooveshark::Client.new(session_token)
    stream_url = client.get_song_url_by_id(song_id)
    stream_key = client.get_stream_auth_by_songid(song_id)
    # print out the stream key in JSON format
    render :json => stream_key
  end
  
  # Renders a song searching interface to the user.
  def search
    # Rails automatically rails the corresponding "search" view.
  end

  # Runs a TinySong search with the passed query, and renders a table of the
  # results. The song ID's which are returned by this request correspond to
  # Grooveshark songs.
  def songs_from_query
    query = URI.escape(params[:query])
    url = URI.parse("#{TINY_SONG_API}/s/#{query}?format=json&limit=#{NUM_SEARCH_RESULTS}&key=#{TINY_SONG_API_KEY}")
    response = Net::HTTP.get_response(url).body
    render :json => response
  end

  private
  
  # If no Grooveshark session token has been generated, creates one. Otherwise,
  # returns the Grooveshark token for the current session. This token can be
  # used to access the internal Grooveshark API.
  def session_token
    if !session[:grooveshark_token]
      client = Grooveshark::Client.new
      session[:grooveshark_token] = client.session
    else
      session[:grooveshark_token]
    end
  end
end
