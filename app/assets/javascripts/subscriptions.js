/**
 * Handles front-end functions for subscribing to/unsubscribing from users
 * Functions handle AJAX requests and replacing the text to update the state
 * Used from either the user's list of subscriptions or a user's profile page
 *
 * Author: Tyler Rigsby, Alex Miller
 */

/*
 * Function for subscribing to a user from the show user page. Makes DOM changes
 * and ajax request for subscribing.
 */
function showSubscribe(id, username) {
    $("a#subscribe").text("Unsubscribe");
    $("a#subscribe").attr("onclick", "showUnsubscribe(" + id + ", '" + username + "'); return false;");
    subscribe(id, username);
}

/*
 * Handles the functionality that is common to subscribing to a user from
 * the list page and the show user page. Includes some DOM changes and the
 * AJAX request.
 */
function subscribe(id, username) {
    showMessage("Subscribed to " + username + ".");
    var url = "/subscriptions/";
    $.post(url, {id: id});
}

/*
 * Function for subscribing to a user from the show user page. Makes DOM changes
 * and ajax request for subscribing.
 */
function showUnsubscribe(id, username) {
    $("a#subscribe").text("Subscribe");
    $("a#subscribe").attr("onclick", "showSubscribe(" + id + ", '" + username + "'); return false;");
    unsubscribe(id, username);
}

/*
 * Function for unsubscribing to a user from the subscriptions list page. Makes DOM changes
 * and ajax request for unsubscribing.
 */
function listUnsubscribe(id, username, element) {
    var row = $(element);
    row.text("Unsubscribed!");
    unsubscribe(id, username);
}

/*
 * Handles the functionality that is common to unsubscribing to a user from
 * the list page and the show user page. Includes some DOM changes and the
 * AJAX request.
 */
function unsubscribe(id, username) {
    showMessage("Subscribed to " + username + ".");
    var url = "/subscriptions/" + id;
    $.ajax({url: url, type: "DELETE"});
}