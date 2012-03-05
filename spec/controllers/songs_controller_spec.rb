require 'spec_helper'

# Test the SongsController. White-box test.
# Author:: Brett Webber
describe SongsController do

  # Sets up the necessary creation parameters for Song, Album, and Artist
  before(:each) do
    @song_attr = {
      :title => "Example Song Title",
      :api_id => "123"
    }
    @album_attr = {
      :title => "Example Album Name"
    }
    @artist_attr = {
      :title => "Example Artist Name"
    }
  end

  # All of the tests having to do with the creation of the Song/Album/Artist combination
  describe "POST 'create'" do

    # A new song should be created under normal circumstances
    it "should create a new song" do
      post :create, :song => (@song_attr), :album => (@album_attr), :artist => (@artist_attr)
      song = Song.find_by_title(@song_attr[:title])
      song.should_not be_nil
    end

    # A new album should be created under normal circumstances
    it "should create a new album" do
      post :create, :song => (@song_attr), :album => (@album_attr), :artist => (@artist_attr)
      album = Album.find_by_title(@album_attr[:title])
      album.should_not be_nil
    end

    # A new artist should be created under normal circumstances
    it "should create a new artist" do
      post :create, :song => (@song_attr), :album => (@album_attr), :artist => (@artist_attr)
      artist = Artist.find_by_title(@artist_attr[:title])
      artist.should_not be_nil
    end

    # A Song should not be created when its title is invalid
    it "should not create song when song has invalid title" do
      post :create, :song => (@song_attr.merge(:title => "")), :album => (@album_attr), :artist => (@artist_attr)      
      Song.find_by_title("").should be_nil
    end

    # An Album should not be created when its title is invalid    
    it "should not create album when album has invalid title" do
      post :create, :song => (@song_attr), :album => (@album_attr.merge(:title => "")), :artist => (@artist_attr)      
      Album.find_by_title(@album_attr[:title]).should be_nil
    end

    # An Artist should not be created when its title is invalid    
    it "should not create artist when artist has invalid title" do
      post :create, :song => (@song_attr), :album => (@album_attr), :artist => (@artist_attr.merge(:title => ""))      
      Artist.find_by_title(@artist_attr[:title]).should be_nil
    end

    # A new Album should not be created when there is already an Album with the same name, a reference to it should be used for the Song    
    it "should not create new album when one with same name exists" do
      post :create, :song => (@song_attr), :album => (@album_attr), :artist => (@artist_attr)
      post :create, :song => (@song_attr.merge(:api_id => "1234")), :album => (@album_attr), :artist => (@artist_attr)
      song1 = Song.find_by_api_id(@song_attr[:api_id])
      song2 = Song.find_by_api_id(1234)
      song1.album.should eq(song2.album)
    end

    # A new Artist should not be created when there is already an Artist with the same name, a reference to it should be used for the Song    
    it "should not create new artist when one with same name exists" do
      post :create, :song => (@song_attr), :album => (@album_attr), :artist => (@artist_attr)
      post :create, :song => (@song_attr.merge(:api_id => "1234")), :album => (@album_attr), :artist => (@artist_attr)
      song1 = Song.find_by_api_id(@song_attr[:api_id])
      song2 = Song.find_by_api_id(1234)
      song1.artist.should eq(song2.artist)
    end

    # All of the Songs associated with an Album should be accessible by calling its songs field
    it "should create multiple songs on an album with multiple songs referencing it" do
      post :create, :song => (@song_attr), :album => (@album_attr), :artist => (@artist_attr)
      post :create, :song => (@song_attr.merge(:api_id => "1234")), :album => (@album_attr), :artist => (@artist_attr)
      album = Album.find_by_title(@album_attr[:title])
      album.songs.length.should eq(2)
    end

    # All of the Songs associated with an Artist should be accessible by calling its songs field
    it "should create multiple songs to an artist with multiple songs referencing it" do
      post :create, :song => (@song_attr), :album => (@album_attr), :artist => (@artist_attr)
      post :create, :song => (@song_attr.merge(:api_id => "1234")), :album => (@album_attr), :artist => (@artist_attr)
      artist = Artist.find_by_title(@artist_attr[:name])
      artist.songs.length.should eq(2)
    end

    # Multiple Songs with the same name should be allowed to exist in the table
    it "should allow multiple songs with the same title to be added" do
      post :create, :song => (@song_attr), :album => (@album_attr), :artist => (@artist_attr)
      post :create, :song => (@song_attr.merge(:api_id => "1234")), :album => (@album_attr), :artist => (@artist_attr)
      songs = Song.find_all_by_title(@song_attr[:title])
      songs.length.should eq(2)
    end
  end
end
