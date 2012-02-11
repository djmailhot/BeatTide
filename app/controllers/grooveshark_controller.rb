class GroovesharkController < ApplicationController
  def getInfo
    songID = params['query']
    client = Grooveshark::Client.new(sessionToken)
    stream_url = client.get_song_url_by_id(songID)
    stream_key = client.get_stream_auth_by_songid(songID)
    render :json => stream_key
  end
  
  def findSong
  end

  def searchSong
    #api_key = "4539534e418cc829a9a2d0c590573a25"
    api_key = "d44e54b31d4333b5940119c69fddc429"
    query = URI.escape(params[:query])
    url = URI.parse("http://tinysong.com/s/#{query}?format=json&limit=10&key=#{api_key}")
    response = Net::HTTP.get_response(url).body
    render :text => response
  end

  def playSong
  end
  
  private
    
  def sessionToken
    if !session[:grooveshark_token]
      client = Grooveshark::Client.new
      session[:grooveshark_token] = client.session
    else
      session[:grooveshark_token]
    end
  end
end
