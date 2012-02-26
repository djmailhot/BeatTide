/**
 * Handles front-end functions for subscribing to/unsubscribing from users
 * Functions handle AJAX requests and replacing the text to update the state
 *
 * Author: Tyler Rigsby
 */

/*
 * Handles AJAX request for unsubscribing to a user. Accepts id as a parameter
 * representing the user id of the user to unsubscribe from.
 */
function unsubscribe(id) {
    var url = "/subscriptions/" + id;
    $.ajax(url, 
	   {
	       type: "DELETE", 
	       complete: function(data) {
		   if (status == "error")
		       ajaxFailure(data);
		   else {
    		       $("#subscription_form").html("Unsubscribed! ");
		       $("#subscription_form").append("<a href='#' onclick='subscribe(" + id + "); return false;'>Subscribe</a>");
		   }    
	       }
	   });
}

/*
 * Handles AJAX request for subscribing to a user. Accepts id as a parameter
 * representing the user id of the user to subscribe from.
 */
function subscribe(id) {
    var url = "/subscriptions?id=" + id;
    $.ajax(url, 
	   {
	       type: "POST", 
	       complete: function(data, status) {
		   if (status == "error")
		       ajaxFailure(data);
		   else {
    		       $("#subscription_form").html("Subscribed! ");
		       $("#subscription_form").append("<a href='#' onclick='unsubscribe(" + id + "); return false;'>Unsubscribe</a>");
		   }
	       }    
	   });
}

