/**
*  Functions for handling the playing and streaming of songs. Sets up the
*  Grooveshark Flash player.
*  
*  Authors: Harnoor Singh, Alex Miller
*/

/**
*  When the page is loaded, setup the Grooveshark Flash Player.
*/
$(document).ready(function() {
    initializeBeatTideNameSpace();
    setupPlayer();
    // global variable to keep track of the currently playing song
    window.BEATTIDE.songPlayer = {}
    window.BEATTIDE.songPlayer.currentSong = {};
    window.BEATTIDE.songPlayer.state = "empty";
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
    player.pauseStream();
    BEATTIDE.songPlayer.state = "paused";
}

/**
*  Plays the current song.
*/
function playStream() {
    if (BEATTIDE.songPlayer.state == "stopped") {
        playSong(BEATTIDE.songPlayer.currentSong);        
    } else if (BEATTIDE.songPlayer.state == "paused") {
        player.resumeStream();
    } else {
        // nothing to do?
    }
}

/**
*  Stops the currently playing song.
*/
function stopStream() {
    player.stopStream();
    BEATTIDE.songPlayer.state = "stopped";
}

/**
*  Accepts a songInfo object, retrieves a stream key from Grooveshark, and then
*  plays the corresponding song in the Flash player. The songInfo object must
*  have the following fields: songID, name, artist, album.
*/
function playSong(songInfo) {
    stopStream();
    BEATTIDE.songPlayer.state = "empty";
    console.log("Requesting stream key for song: " + songInfo.id);
    $.ajax({
        url: "song_stream_info",
        dataType: 'json',
        data: {query: songInfo.id},
        success: function(json) {
            console.log(json);
            console.log("Stream key retreived: " + json['stream_key']);
            player.playStreamKey(json['stream_key'], json['ip'], json['stream_server_id']);
            BEATTIDE.songPlayer.currentSong.id = songInfo.id;
            BEATTIDE.songPlayer.currentSong.name = songInfo.name;
            BEATTIDE.songPlayer.currentSong.artist = songInfo.artist;
            BEATTIDE.songPlayer.currentSong.album = songInfo.album;
            BEATTIDE.songPlayer.state = "playing";
        },
        error: ajaxFailure
    });
}

/**
*  Event listener for when a song play button is clicked.
*/
function onPlayButtonClicked(event) {
    playSong(event.target.id);
}