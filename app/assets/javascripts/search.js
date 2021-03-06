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

$(document).delegate('#song_search_box', 'keypress', function(event){
    if(event.keyCode == 13){
        performSearch();
    }
});
$(document).delegate('#song_search_button', 'click', performSearch);

/**
 * Retrieves the search query from the search input box and then loads the 
 * search results with AJAX. The search results are obtained from the Grooveshark
 * controller.
 */
function performSearch() {
    var searchString = $('#song_search_box').val();
    var url = "grooveshark/songs_from_query";
    $("#search_results").html('<img src="assets/load_small.gif" /> Loading...');
    $.ajax({
	url: url, 
	type: "get",
	data: {query: searchString}, 
	success: function(data) {
            $("#search_results").html(data);
	},
	error: function(data) {
	    $("#search_results").text("Search could not be completed. Please try again later.");
	},
	timeout: 10000	  
    });
}