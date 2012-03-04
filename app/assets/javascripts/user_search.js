
/**
 * Initializes the user searching interface and sends search requests to the
 * Users controller. 
 *  
 * Author: Harnoor Singh
 */

/**
 * Attach listeners when the document is loaded
 */
$(document).ready(function() {
    $('#user_search_box').keypress(function(event){
        if(event.keyCode == 13){
            performUserSearch();
        }
    });

    $('#user_search_button').click(performUserSearch);
    $('#user_search_box').Watermark("Search for user...");
});

/**
 * Gets the query parameter from the search box and calls the find_user controller. 
 * Injects the results into the page.
 */
function performUserSearch() {
    var searchString = $('#user_search_box').val();
    console.log("Searching for user: " + searchString);
    var url = "find_user";
    $("#search_results").load(url, {query: searchString}, function(response, status, hxr){
    	if(status == "error"){
    	    ajaxFailure(hxr, status);
    	}
    });
}