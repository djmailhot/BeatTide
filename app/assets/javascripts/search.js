/*
This is the JavaScript handlers for the search page. It handles interaction with
the TinySong API as well as controlling the groovehsark swf object.  

Authors: Harnoor Singh, Alex Miller
*/

$(document).ready(function() {
    $('#song_search_box').focus();
    $('#song_search_box').keypress(function(event){
        if(event.keyCode == 13){
            performSearch();
        }
    });
    $('#song_search_button').click(performSearch);
});

// Query the TinySong API 
function performSearch() {
    var searchString = $('#song_search_box').val()
    console.log("Sending request for search query: '" + searchString + "'");
    var url = "songs_from_query";
    $("#search_results").load(url, {query: searchString}, refreshPlayButtons);
}
