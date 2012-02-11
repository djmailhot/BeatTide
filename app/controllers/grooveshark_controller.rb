class GroovesharkController < ApplicationController
  def getInfo
    songID = params['query']
    
    # Can we optimize this so we don't create a new session every time?
    client = Grooveshark::Client.new
    session = client.session
 
    @stream_url = client.get_song_url_by_id(songID)
    @stream_key = client.get_stream_auth_by_songid(songID)
    render :json => @stream_key
#    render :text => @stream_key
#    render :text => resp['stream_key']
    # pass this to the APIPlayer swf 
  end

  def findSong
  end

  def searchSong
    api_key = "d44e54b31d4333b5940119c69fddc429"
    query = URI.escape(params[:query])

    url = URI.parse("http://tinysong.com/s/#{query}?format=json&limit=10&key=#{api_key}")
    response = Net::HTTP.get_response(url).body
    render :text => response

  end

  def playSong
  end  
end
