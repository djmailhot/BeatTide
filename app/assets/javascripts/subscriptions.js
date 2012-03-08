/**
 * Handles front-end functions for subscribing to/unsubscribing from users
 * Functions handle AJAX requests and replacing the text to update the state
 * Used from either the user's list of subscriptions or a user's profile page
 *
 * Author: Tyler Rigsby, Alex Miller
 */

/*
 * Handles AJAX request for subscribing to a user. Accepts id as a parameter
 * representing the user id of the user to subscribe from.
 */
function subscribe(id, username) {
    showMessage("Subscribed to " + username + ".");
    var url = "/subscriptions/";
    $.post(url, {id: id}, function(data, status) {
        $("a#subscribe").text("Unsubscribe");
        $("a#subscribe").attr("onclick", "unsubscribe(" + id + ", '" + username + "'); return false;");
    });
}

/*
 * Handles AJAX request for unsubscribing to a user. Accepts id as a parameter
 * representing the user id of the user to unsubscribe from.
 */
function unsubscribe(id, username) {
    showMessage("Unsubscribed to " + username + ".");
    var url = "/subscriptions/" + id;
    $.ajax({
        url: url,
        type: "DELETE", 
        complete: function(data) {
            $("a#subscribe").text("Subscribe");
            $("a#subscribe").attr("onclick", "subscribe(" + id + ", '" + username + "'); return false;");
        }
    });
}