/**
 * A place for generic, common functions.
 *  
 * Authors: Harnoor Singh, Alex Miller
 */

/**
 * Creates the global BEATTIDE object for storing global javascript variables.
 */
function initializeBeatTideNameSpace() {
    if (typeof BEATTIDE == "undefined") {
        window.BEATTIDE = {};
    }
}

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