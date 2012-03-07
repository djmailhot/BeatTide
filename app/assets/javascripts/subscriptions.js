/**
 * Handles front-end functions for subscribing to/unsubscribing from users
 * Functions handle AJAX requests and replacing the text to update the state
 * Used from either the user's list of subscriptions or a user's profile page
 *
 * Author: Tyler Rigsby
 */

/*
 * Callback for unsubscribing from a user from their profile page.
 * Changes link on profile page to 'Subscribe'
 */
function showUnsubscribeCallback(id) {
    var link = $("<a></a>");
    link.attr("href", "#");
    link.attr("onclick", "subscribe(" + id + ", showSubscribeCallback); return false;");
    link.text("Subscribe");
    $("#subscription_form").text("Unsubscribed! ");
    $("#subscription_form").append(link);
}

/*
 * Callback for unsubscribing from a user from your list of subscriptions.
 * Changes the text in the Unsubscribe box to "Unsubscribed!"
 */
function listUnsubscribeCallback(id) {
    var row = $("#" + id);
    row.children(".button").text("Unsubscribed!");
}

/*
 * Handles AJAX request for unsubscribing to a user. Accepts id as a parameter
 * representing the user id of the user to unsubscribe from.
 */
function unsubscribe(id, successCallback) {
    var url = "/subscriptions/" + id;
    $.ajax(url, 
	   {
	       type: "DELETE", 
	       complete: function(data) {
		   if (status == "error")
		       ajaxFailure(data);
		   else {
		       successCallback(id);
		   }    
	       }
	   });
}

/*
 * Callback for subscribing to a user from their profile page.
 * Sets the link to 'Unsubscribe' and informs the user they have subscribed
 */
function showSubscribeCallback(id) {
    var link = $("<a></a>");
    link.attr("href", "#");
    link.attr("onclick", "unsubscribe(" + id + ", showUnsubscribeCallback); return false;");
    link.text("Unubscribe");
    $("#subscription_form").text("Subscribed! ");
    $("#subscription_form").append(link);
}

/*
 * Handles AJAX request for subscribing to a user. Accepts id as a parameter
 * representing the user id of the user to subscribe from.
 */
function subscribe(id, successCallback) {
    var url = "/subscriptions?id=" + id;
    $.ajax(url, 
	   {
	       type: "POST", 
	       complete: function(data, status) {
		   if (status == "error")
		       ajaxFailure(data);
		   else {
		       successCallback(id);
		   }
	       }    
	   });
}

