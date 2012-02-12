// On load attach a listener for the return key
$(document).ready(function() {
    $('#searchBox').focus();
    $('#searchBox').keypress(function(event){
	if(event.keyCode == 13){
	    findSong($('#searchBox').val());
	}
    });
    $('#pause').click(pauseStream);
    $('#play').click(playStream);
    $('#stop').click(stopStream);
    $('.play_song').click(function() {
       console.log("PLAY");
    });
});

function pauseStream(){
    window.player.pauseStream();
}

function playStream(){
    window.player.resumeStream();
}

function stopStream(){
    window.player.stopStream();
}

function refreshPlayButtons() {
    $('.play_song').click(onPlayButtonClicked);
}

function onPlayButtonClicked(event){
    playSong(event.target.id);
}

// Get the stream key from the grooveshark gem
function playSong(songID){
    console.log(songID);
    $.getJSON("song_stream_info", {query: songID}, activateWidget);
}

function activateWidget(json){
    var stream_key = json['stream_key'];
    var host_name = json['ip'];
    var server_id = json['stream_server_id'];
	console.log("Streaming Info");
	console.log("\tStream Key: " + stream_key);
	console.log("\tStream Server: " + host_name);
	console.log("\tStream Server ID: " + server_id);
    window.player.setVolume(99);
    window.player.playStreamKey(stream_key, host_name, server_id);
}