/**
 * Functions for handling the playing and streaming of songs. Sets up the
 * Grooveshark Flash player.
 * 
 * Authors: Harnoor Singh, Alex Miller
 */

/**
 *  When the page is loaded, setup the Grooveshark Flash Player.
 */
$(document).ready(function() {
    initializeBeatTideNameSpace();
    // global variable to keep track of the currently playing song
    window.BEATTIDE.songPlayer = {}
    window.BEATTIDE.songPlayer.currentSong = {};
    setPlayerState("stopped");
});

function stopStream() {
    player.stopStream();
    setPlayerState("disabled");
}

/**
 * Plays the current song.
 */
function playButtonClicked() {
    switch (BEATTIDE.songPlayer.state) {
        case "paused":
            player.resumeStream();
            setPlayerState("playing");
            break;
        case "playing":
            player.pauseStream();
            setPlayerState("paused");
            break;
    }
}

function setPlayerState(state) {
    BEATTIDE.songPlayer.state = state;
    $("#player_container #play_pause").removeClass("play");
    $("#player_container #play_pause").removeClass("pause");
    $("#player_container #play_pause").removeClass("disabled");
    if (state == "playing" || state == "paused") {
        $("#current_song_info").html("<strong>" + BEATTIDE.songPlayer.currentSong.name
            + "</strong> by " + BEATTIDE.songPlayer.currentSong.artist);
        if (state == "playing") {
            $("#player_container #play_pause").addClass("pause");
        } else {
            $("#player_container #play_pause").addClass("play");
        }
    } else {
        $("#current_song_info").html("<em>No song</em>");
        $("#player_container #play_pause").addClass("disabled");    
    }
}

/**
 * Accepts a songInfo object, retrieves a stream key from Grooveshark, and then
 * plays the corresponding song in the Flash player. The songInfo object must
 * have the following fields: songID, name, artist, album.
 */
function playSong(songInfo) {
    stopStream();
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
            setPlayerState("playing");
        },
        error: ajaxFailure
    });
}

/**
 * Event listener for when a song play button is clicked.
 */
function onPlayButtonClicked(event) {
    playSong(event.target.id);
}