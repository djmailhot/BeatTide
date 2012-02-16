var TinySongKey = "d44e54b31d4333b5940119c69fddc429";

var TinySongURL = "http://tinysong.com/";


/* Methods
 	/s/ 
	
		http://tinysong.com/s/searchTerm?format=json&limit=3&key=APIkey
*/			
var TinySongMethod = "/s/";
var limit = 5;


document.observe("dom:loaded", function() {
	$('searchBox').focus();
	$('searchBox').observe('keypress', function(event){
    if(event.keyCode == 13){
			findSong($('searchBox').value);
		}
	});
});

function findSong(searchString) {

	new Ajax.Request("http://students.washington.edu/hsingh09/BeatTide/findSong.php?query=" + searchString,
	{
		method:'get',
		onSuccess: displaySong,
		onFailure: ajaxFailure,
		onException: ajaxFailure
	});
	
}

/*
	$.ajax({
		url: 'api/idGetter.php?query=' + searchString,
		dataType: 'jsonp',
		success: function(data) {
	  	playSong(data.SongID);
	  }
	});
*/


function displaySong(ajax){
	if($('results').getStyle('visibility') == "hidden"){
		$('results').style.visibility = "visible";
		$('results').blindDown();
	}
	$('results').innerHTML = ajax.responseText;
	
	var songs = $$(".playButton");
	for(var i = 0; i< songs.length; i++){
		$(songs[i].id).observe('click', playSong);
	}
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
