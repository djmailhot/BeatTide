
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
    $(document).delegate('#user_search_box', 'keypress', function(event) {
        if(event.keyCode == 13){
            performUserSearch();
        }
    });
    $(document).delegate('#user_search_button', 'click', performUserSearch);
    $('#user_search_box').Watermark("Search for user...");
});

/**
 * Gets the query parameter from the search box and calls the find_user controller. 
 * Injects the results into the page.
 */
function performUserSearch() {
    var searchString = $('#user_search_box').val();
    console.log("Searching for user: " + searchString);
    var url = "users/find_user";
    $("#search_results").html('<img src="assets/load_small.gif" /> Loading...');
    
    $("#search_results").html('<img src="assets/load_small.gif" /> Loading...');
    $.post(url, {query: searchString}, function(data) {
        $("#search_results").html(data);
    });
}