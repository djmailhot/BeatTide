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

  def playSong
  end
end
