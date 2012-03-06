/**
 * A place for generic, common functions.
 *  
 * Authors: Harnoor Singh, Alex Miller
 */

/**
 * Prints out an AJAX request failure for debugging.
 */
function ajaxFailure(ajax, exception){
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

$(document).on('ajax:beforeSend', '.button-link', function() {
  alert("Success!");
});
