// On load attach a listener for the return key
$(document).ready(function() {
    setupPlayer();
});

function setupPlayer() {
    $('#pause').click(pauseStream);
    $('#play').click(playStream);
    $('#stop').click(stopStream);
}

function pauseStream(){
    window.player.pauseStream();
}

function playStream(){
    window.player.resumeStream();
}

function stopStream(){
    window.player.stopStream();
}

// Get the stream key from the grooveshark gem
function playSong(songID){
    console.log("Requesting stream key for song: " + songID);
    $.getJSON("song_stream_info", {query: songID}, function(json) {
        console.log("Stream key retreived: " + json['stream_key']);
        window.player.playStreamKey(json['stream_key'], json['ip'], json['stream_server_id']);
    });
}

function refreshPlayButtons() {
    $('.play_song').click(onPlayButtonClicked);
}

function onPlayButtonClicked(event){
    playSong(event.target.id);
}