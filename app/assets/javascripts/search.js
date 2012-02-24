/**
 * Initializes the song searching interface and sends search requests to the
 * Grooveshark controller. 
 *  
 * Authors: Harnoor Singh, Alex Miller
 */

/**
 * Runs with the document is loaded. Sets up the search interface and positions
 * the user's cursor within the search box.
 */
$(document).ready(function() {
    $('#song_search_box').keypress(function(event){
        if(event.keyCode == 13){
            performSearch();
        }
    });

    $('#song_search_button').click(performSearch);
    $('#song_search_box').Watermark("Search for song...");

});


/**
 * Retrieves the search query from the search input box and then loads the 
 * search results with AJAX. The search results are obtained from the Grooveshark
 * controller.
 */
function performSearch() {
    var searchString = $('#song_search_box').val();
    console.log("Sending request for search query: '" + searchString + "'");
    var url = "grooveshark/songs_from_query";
    $("#search_results").load(url, {query: searchString}, function(response, status, xhr) {
        if (status == "error") {
            ajaxFailure(xhr, status);
        }
    });
}