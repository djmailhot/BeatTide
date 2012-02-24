function postSong(songID) {
    $.post("/posts", {api_id: songID}, function(data, textStatus, jqXHR) {
        console.log(data);
        $.get("/posts/show_raw", {id: data.id}, function(post, textStatus, jqXHR) {
            $("#your_songs .post_list").prepend(post);
        });
    });
    
}