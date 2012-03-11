/**
 * A place for generic, common functions.
n *  
 * Authors: Harnoor Singh, Alex Miller, Tyler Rigsby
 */

// Variable to manage song autoplay

var hasAutoplayed = false;

/**
 * Prints out an AJAX request failure for debugging.
 */
function ajaxFailure(ajax, exception) {
    console.log("Error making Ajax request:" + 
          "\n\nServer status:\n" + ajax.status + " " + ajax.statusText + 
          "\n\nServer response text:\n" + ajax.responseText);
    if (exception) {
	    throw exception;
    }
}

/**
 * Shows a message to the user at the top of the page.
 */  
function showMessage(message) {
    var m = document.createElement("div");
    m.innerHTML = message;
    $(m).addClass("message");
    $("#message_container").html('');
    $("#message_container").append(m);
    $("#close").click(hideMessage);
    $(m).stop().delay(1000).fadeOut(1000, function() {
        hideMessage();
    });
}

/**
 * Hides the message.
 */  
function hideMessage() {
    $("#message_container").html('');
}

/**
 * Extracts the route to the requested partial from the URL and loads the content 
 * asynchronously. Relies on '#!' prefixing every path.
 */
function loadPartial() {
    $("#dynamic_content_container").html('<div class="module loading"><h2>Loading...</h2><img src="/assets/load.gif" /></div>');
    $.ajax({
    	url: window.location.hash.replace("#!", ""),
    	success: function(data) {
    	    $("#dynamic_content_container").html(data);
    	},
    	error: function(data) {
    	    var div = $("<div class='module'><h2>Requested page could not be loaded</h2><a href='/#!/home'>Go home</a></div>");
    	    $("#dynamic_content_container").html(div);
    	},
    	dataType: "html",
	    timeout: 10000
    });
}

$(document).ready(function() {
    // set up all the path listeners. when a path matches one of the following
    // patterns, the page is not refreshed. instead, an asynchronous request 
    // loads the content.
    Path.root("#!/home");
    Path.map("#_=_").to(loadPartial);
    // this is messy, but PathJS doesn't have powerful wildcard matching
    Path.map("#!/:a").to(loadPartial);
    Path.map("#!/:a/:b").to(loadPartial);
    Path.map("#!/:a/:b/:c").to(loadPartial);
    Path.map("#!//:a").to(loadPartial);
    Path.map("#!//:a/:b").to(loadPartial);
    Path.map("#!//:a/:b/:c").to(loadPartial);
    Path.listen();
});
