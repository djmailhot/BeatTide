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
    var url = "http://localhost:3000/grooveshark/searchSong";
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
	content += "<td>" + json[i].SongID + "</td>";
	content += "<td>" + json[i].SongName + "</td>";
	content += "<td>" + json[i].ArtistName + "</td>";
	content += "</tr>";
/*
	$('#results').append("<tr>");
	$('#results').append("<td>" + json[i].SongID + "</td>");
	$('#results').append("<td>" + json[i].SongName + "</td>");
	$('#results').append("<td>" + json[i].ArtistName + "</td>");
	$('#results').append("</tr>");
*/
    }
    	//$('#results').append("</table>");

    content += "</table>";
    $('#results').html(content);

/*    if($('results').getStyle('visibility') == "hidden"){
	$('results').style.visibility = "visible";
	$('results').blindDown();
    }
    $('results').innerHTML = ajax.responseText;
    
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
