/*
  This is the JavaScript handlers for the search page. It handles interaction with
  the TinySong API as well as controlling the groovehsark swf object.  

  Author: Harnoor Singh

*/

// TinySong API info and preferences
var TinySongKey = "d44e54b31d4333b5940119c69fddc429";
var TinySongURL = "http://tinysong.com/";
var TinySongMethod = "/s/";
var limit = 5;


var debug = true;

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

// Query the TinySong API 
function findSong(searchString) {
    console.log("Sending request");
    var url = "searchSong";
    $.getJSON(
	url,
	{query: searchString},
	displaySong);
}

// For bad AJAX queries
function getError(a, b, c){
    console.log("GET error");
    console.log(a);
    console.log(b);
    console.log(c);
}

// Parses the JSON object and displays the search results in a table. 
function displaySong(json){
    console.log("Successfully got data");
    $('#results').css("visibility", "visible");
    $('#results').html("");
    var content = "<table><tr><th></th><th>Song Name</th><th>Artist</th></tr>";
    for(var i = 0; i < json.length; i++){
	content += "<tr>";
	//id=" + json[i].SongID
	content += "<td><img height='30' width='30' id='" + json[i].SongID + "' class='playButton' src='http://students.washington.edu/hsingh09/BeatTide/img/play.png'></td>";
	content += "<td>" + json[i].SongName + "</td>";
	content += "<td>" + json[i].ArtistName + "</td>";
	content += "</tr>";

    }

    content += "</table>";
    $('#results').html(content);

    // Attach listeners to each play button
    var songs = $(".playButton");
    for(var i = 0; i< songs.length; i++){
	$('#' + songs[i].id).click(playListener);
    }
}

function playListener(event){
    playSong(event.target.id);
}

// Get the stream key from the grooveshark gem
function playSong(songID){
    console.log(songID);
    $.getJSON(
	"getInfo", 
	{query: songID},
	activateWidget);
}

function activateWidget(json){
    var stream_key = json['stream_key'];
    var host_name = json['ip'];
    var server_id = json['stream_server_id'];

    if(debug){
	console.log("Streaming Info");
	console.log("\tStream Key: " + stream_key);
	console.log("\tStream Server: " + host_name);
	console.log("\tStream Server ID: " + server_id);
    }
    window.player.setVolume(99);
    window.player.playStreamKey(stream_key, host_name, server_id);
}


function ajaxFailure(ajax, exception){
    console.log("Error making Ajax request:" + 
          "\n\nServer status:\n" + ajax.status + " " + ajax.statusText + 
          "\n\nServer response text:\n" + ajax.responseText);
    if (exception) {
	throw exception;
    }
}
