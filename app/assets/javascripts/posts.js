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