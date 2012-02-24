function postSong(songID) {
    $.post("/posts", {api_id: songID}, function(data, textStatus, jqXHR) {
        location.reload();
    });
}