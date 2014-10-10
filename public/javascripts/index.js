$(document).ready(function() {
    $(".hashtag_inputs").on("change", function() {
        $("#hashtag").append("#" + $(".hashtag_inputs:checked").val());
    });
})
