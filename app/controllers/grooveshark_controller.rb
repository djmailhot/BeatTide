class GroovesharkController < ApplicationController
  def getInfo
    client = Grooveshark::Client.new
    session = client.session
    render :text => session
    songs = client.search_songs('Nirvana')
    songs.each do |s|
      s.name
    end
  end

  def findSong
  end

  def playSong
  end
end
