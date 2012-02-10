var TinySongKey = "d44e54b31d4333b5940119c69fddc429";
var TinySongURL = "http://tinysong.com/";

var TinySongMethod = "/s/";
var limit = 5;


$(document).ready(function() {
    $('#searchBox').focus();
    $('#searchBox').keypress(function(event){
	if(event.keyCode == 13){
	    findSong($('#searchBox').val());
	}
    });
});


function findSong(searchString) {
    console.log("Sending request");
    var url = "searchSong";
    $.getJSON(
	url,
	{query: searchString},
	displaySong);
}

function getError(a, b, c){
    console.log("GET error");
    console.log(a);
    console.log(b);
    console.log(c);
}


function displaySong(json){
    console.log("Successfully got data");
    $('#results').css("visibility", "visible");
    $('#results').html("");
    var content = "<table><tr><th></th><th>Song Name</th><th>Artist</th></tr>";
    for(var i = 0; i < json.length; i++){
	content += "<tr>";
	content += "<td id=" + json[i].SongID + "><img height='30' width='30' src='http://students.washington.edu/hsingh09/BeatTide/img/play.png'></td>";
	content += "<td>" + json[i].SongName + "</td>";
	content += "<td>" + json[i].ArtistName + "</td>";
	content += "</tr>";

    }

    content += "</table>";
    $('#results').html(content);
/*
    var songs = $$(".playButton");
    for(var i = 0; i< songs.length; i++){
	$(songs[i].id).observe('click', playSong);
    }*/
}

function playSong(event){
    var element = Event.element(event);
    var songID = element.id;
    console.log(songID);
    
    new Ajax.Request("http://students.washington.edu/hsingh09/BeatTide/GenerateWidget.php?songID=" + songID,
		     {
			 method:'get',
			 onSuccess: displayWidget,
			 onFailure: ajaxFailure,
			 onException: ajaxFailure
		     });

}

function displayWidget(ajax){
    $('player').innerHTML = ajax.responseText;
}


function ajaxFailure(ajax, exception){
    alert("Error making Ajax request:" + 
          "\n\nServer status:\n" + ajax.status + " " + ajax.statusText + 
          "\n\nServer response text:\n" + ajax.responseText);
    if (exception) {
	throw exception;
    }
}
