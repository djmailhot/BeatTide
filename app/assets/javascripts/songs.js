/**
*  Functions for handling the playing and streaming of songs. Sets up the
*  Grooveshark Flash player.
*  
*  Important: Whenever new play buttons are added to the DOM, the refreshPlayButtons
*  function must be called to add event listeners to those buttons.
*  
*  Authors: Harnoor Singh, Alex Miller
*/

/**
*  When the page is loaded, setup the Grooveshark Flash Player.
*/
$(document).ready(function() {
    setupPlayer();
});

/**
*  Adds the Grooveshark Flash player to the page, and adds event listeners to the
*  player control buttons.
*/
function setupPlayer() {
    swfobject.embedSWF("http://grooveshark.com/APIPlayer.swf","player", "1", "1", "9.0.0", "", {},
        {allowScriptAccess: "always"}, {id:"player", name:"groovesharkPlayer"},
        function(e) {
            var element = e.ref;
            if (element) {
                setTimeout(function() {
                    window.player = element;
                    window.player.setVolume(99);
                }, 1500);
            } else {
                console.log("couldn't load flash");
            }
        }
    );
    $('#pause').click(pauseStream);
    $('#play').click(playStream);
    $('#stop').click(stopStream);
}

/**
*  Pauses the currently playing song.
*/
function pauseStream() {
    window.player.pauseStream();
}

/**
*  Plays the current song.
*/
function playStream() {
    window.player.resumeStream();
}

/**
*  Stops the currently playing song.
*/
function stopStream() {
    window.player.stopStream();
}

/**
*  Accepts a songID, retrieves a stream key from Grooveshark, and then plays the
*  corresponding song in the Flash player.
*/
function playSong(songID) {
    console.log("Requesting stream key for song: " + songID);
    $.getJSON("song_stream_info", {query: songID}, function(json) {
        console.log("Stream key retreived: " + json['stream_key']);
        window.player.playStreamKey(json['stream_key'], json['ip'], json['stream_server_id']);
    });
}

/**
*  Adds click event listeners to all song play buttons on the page.
*/
function refreshPlayButtons() {
    $('.play_song').click(onPlayButtonClicked);
}

/**
*  Event listener for when a song play button is clicked.
*/
function onPlayButtonClicked(event) {
    playSong(event.target.id);
}