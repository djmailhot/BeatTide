/**
 * A place for generic, common functions.
 *  
 * Authors: Harnoor Singh, Alex Miller
 */

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
    m.innerHTML = message + " <a href='#' id='close'>Close.</a>";
    $(m).addClass("message");
    $(m).addClass("module");
    $(m).addClass("small_module");
    $("#message_container").html('');
    $("#message_container").append(m);
    $("#close").click(hideMessage);
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
    $.get(window.location.hash.replace("#!", ""), function(data) {
        $("#dynamic_content_container").html(data);
    });
}
  
$(document).ready(function() {
    // set up all the path listeners. when a path matches one of the following
    // patterns, the page is not refreshed. instead, an asynchronous request 
    // loads the content.
    Path.root("#!/home")
    // this is messy, but PathJS doesn't have powerful wildcard matching
    Path.map("#!/:1").to(loadPartial);
    Path.map("#!/:1/:2").to(loadPartial);
    Path.map("#!/:1/:2/:3").to(loadPartial);
    Path.map("#!//:1").to(loadPartial);
    Path.map("#!//:1/:2").to(loadPartial);
    Path.map("#!//:1/:2/:3").to(loadPartial);
    Path.listen();
})