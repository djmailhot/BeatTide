/**
 * Performs a song post to the database in the background, and then attempts to
 * update the #your_songs div (if it is on the current page).
 * 
 * Authors: Alex Miller, David Mailhot
 */
function postSong(songID, element) {
    if (!$(element).hasClass("added")) {
        $(element).addClass("added");
        $.post("/posts", {api_id: songID}, function(data, textStatus, jqXHR) {
            $.get("/posts/show_raw", {id: data.id}, updatePostList);
        });
    }
}

function updatePostList(post) {
    if ($("#your_songs .post_list").length != 0) {
        if ($("#your_songs .post_list").find(".post").length == 0) {
            $("#your_songs .post_list").html(post);   
        } else {
            $("#your_songs .post_list").prepend(post);   
        }
        $("#your_songs .post_list").children().first().css("background-color", "#FFF212").animate({ backgroundColor: "#f7f7f7"}, 500);
    }
    var songName = $(post).find("h3").text();
    showMessage("'" + songName + "' was added to your posts!");
}

/**
 * Submits a like / unlike request to the database and updates the view to
 * reflect the like count.
 */
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
function deletePost(id, element) {
    console.log(element);
    showMessage("Deleted '' from your posted songs.")
    var url = "/posts/" + id;
    // Callback for removing a post from the page after a user has deleted it
    // Removes the post from the page
    // A post can be identified by an id of "pid_<post.id>"
	removePostCallback = function() {
		$("#pid_"+id).remove()
	}
    
    $.ajax(url, 
	   {
	       type: "DELETE", 
           parameters: { id: id },
	       complete: function(data) {
		   if (status == "error")
		       ajaxFailure(data);
		   else {
               removePostCallback();
		   }    
	       }
	   });
}
