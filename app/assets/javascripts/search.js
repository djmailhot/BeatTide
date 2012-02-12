/*
This is the JavaScript handlers for the search page. It handles interaction with
the TinySong API as well as controlling the groovehsark swf object.  

Authors: Harnoor Singh, Alex Miller
*/

// Query the TinySong API 
function findSong(searchString) {
    console.log("Sending request for search query: '" + searchString + "'");
    var url = "songs_from_query";
    $("#results").load(url, {query: searchString}, refreshPlayButtons);
    
}

// For bad AJAX queries
function getError(a, b, c){
    console.log("GET error");
    console.log(a);
    console.log(b);
    console.log(c);
}

function ajaxFailure(ajax, exception){
    console.log("Error making Ajax request:" + 
          "\n\nServer status:\n" + ajax.status + " " + ajax.statusText + 
          "\n\nServer response text:\n" + ajax.responseText);
    if (exception) {
	throw exception;
    }
}
