/**
 * Functions for handling the playing and streaming of songs. Sets up the
 * Grooveshark Flash player.
 * 
 * Authors: Harnoor Singh, Alex Miller
 */

/**
 * Accepts a song div from the view. Creates a comma separated list of song IDs
 * and calls a grooveshark controller to generate the song widget.  Injects the widget
 * into the page.  
 */
function makePlaylist(song) {
  var clickedSong = $(song).closest(".song")[0];
  var found = false;
  var songIdList = "";
  $(song).closest(".playlist_container").find(".song").each(function(index, value) {
    if (!found) {
      if (value == clickedSong) {
        found = true;
        songIdList += $(clickedSong).attr("id");
      }
    } else {
        songIdList += "," + $(value).attr("id");      
    }
  });
  $("#player_container").load("grooveshark/player?song_ids=" + songIdList);
}