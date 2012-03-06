/**
 * Performs a song post to the database in the background, and then attempts to
 * update the #your_songs div (if it is on the current page).
 * 
 * Authors: Alex Miller
 */
function postSong(songID) {
    $.post("/posts", {api_id: songID}, function(data, textStatus, jqXHR) {
        $.get("/posts/show_raw", {id: data.id}, function(post, textStatus, jqXHR) {
            if ($("#your_songs .post_list").length != 0) {
                $("#your_songs .post_list").prepend(post);
            }
            showMessage("Song was added!");
        });
    });   
}
  
function likePost(postID, link) {
    var likes = $(link).closest(".info").children(".like_count");
    var you = $(link).closest(".info").children(".you_like");
    var likeLink = $(you).children("a");
    $.post("/posts/like", {id: postID}, function(data, textStatus, jqXHR) {
	    if ($(likeLink).text() == "Like") {
    	    $(likeLink).text("Unlike");
    	} else {
    	    $(likeLink).text("Like");
    	}
    	if (data == 1){
    	    $(likes).text(data + " person likes this");
    	} else {
            $(likes).text(data + " people like this");
    	}
    });
}

/*
 * Handles AJAX request for deleting a post. Accepts id as a parameter
 * representing the post id of the post to delete.
 */
function deletePost(id) {
    var url = "/posts/destroy";
    $.ajax(url, 
	   {
	       type: "DELETE", 
	       complete: function(data) {
		   if (status == "error")
		       ajaxFailure(data);
		   else {
               alert("deleted!")
		   }    
	       }
	   });
}
