class GroovesharkController < ApplicationController
  def getInfo
    client = Grooveshark::Client.new
    session = client.session
    song = client.get_song_url_by_id(2607986)
    render :text => song
    
    # resp = get_stream_auth by songid(song_id)
    # resp['stream_key']
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
