require 'spec_helper'

# Test the SongsController. White-box test.
# Author:: Brett Webber
describe SongsController do
  
  before(:each) do      
    @song_attr = { 
      :title => "Example Song Title",
      :api_id => "123"
    }
    @album_attr = { 
      :name => "Example Album Name"
    }
    @artist_attr = { 
      :name => "Example Artist Name"
    }
  end
  
  describe "POST 'create'" do

    it "should create a new song" do
      post :create, :song => (@song_attr), :album => (@album_attr), :artist => (@artist_attr)      
      song = Song.find_by_title("Example Song Title")
      song.should_not eq(nil)
    end

    it "should create a new album" do
      post :create, :song => (@song_attr), :album => (@album_attr), :artist => (@artist_attr)      
      album = Album.find_by_name("Example Album Name")
      album.should_not eq(nil)
    end

    it "should create a new artist" do
      post :create, :song => (@song_attr), :album => (@album_attr), :artist => (@artist_attr)      
      artist = Artist.find_by_name("Example Artist Name")
      artist.should_not eq(nil)
    end

    it "should not create song when song has invalid title" do
      post :create, :song => (@song_attr.merge(:title => "")), :album => (@album_attr), :artist => (@artist_attr)      
      Song.find_by_title("").should eq(nil)
    end

    it "should not create album when album has invalid title" do
      post :create, :song => (@song_attr), :album => (@album_attr.merge(:name => "")), :artist => (@artist_attr)      
      Album.find_by_name("Example Song Title").should eq(nil)
    end

    it "should not create artist when artist has invalid title" do
      post :create, :song => (@song_attr), :album => (@album_attr), :artist => (@artist_attr.merge(:name => ""))      
      Artist.find_by_name("Example Song Title").should eq(nil)
    end

    it "should not create new album when one with same name exists" do
      post :create, :song => (@song_attr), :album => (@album_attr), :artist => (@artist_attr)
      post :create, :song => (@song_attr.merge(:api_id => "1234")), :album => (@album_attr), :artist => (@artist_attr)
      song1 = Song.find_by_api_id(123)
      song2 = Song.find_by_api_id(1234)
      song1.album.should eq(song2.album)
    end

    it "should not create new artist when one with same name exists" do
      post :create, :song => (@song_attr), :album => (@album_attr), :artist => (@artist_attr)
      post :create, :song => (@song_attr.merge(:api_id => "1234")), :album => (@album_attr), :artist => (@artist_attr)
      song1 = Song.find_by_api_id(123)
      song2 = Song.find_by_api_id(1234)
      song1.artist.should eq(song2.artist)
    end

    it "should create multiple songs on an album with multiple songs referencing it" do
      post :create, :song => (@song_attr), :album => (@album_attr), :artist => (@artist_attr)
      post :create, :song => (@song_attr.merge(:api_id => "1234")), :album => (@album_attr), :artist => (@artist_attr)
      album = Album.find_by_name("Example Album Name")
      album.songs.length.should eq(2)
    end

    it "should create multiple songs to an artist with multiple songs referencing it" do
      post :create, :song => (@song_attr), :album => (@album_attr), :artist => (@artist_attr)
      post :create, :song => (@song_attr.merge(:api_id => "1234")), :album => (@album_attr), :artist => (@artist_attr)
      artist = Artist.find_by_name("Example Artist Name")
      artist.songs.length.should eq(2)
    end
  end
end
