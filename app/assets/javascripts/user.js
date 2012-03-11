$(document).delegate('#edit_profile_form', 'ajax:beforeSend', function(evt, xhr, status) {
    var submitButton = $('#edit_profile_form input[name="commit"]');
    submitButton.attr("value", "Submitting...");
    submitButton.attr("disabled", "disabled");
});

$(document).delegate('#edit_profile_form', 'ajax:success', function(evt, xhr, status) {
    $("#dynamic_content_container").html(xhr);
});