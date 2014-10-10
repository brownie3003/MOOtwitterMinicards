$(document).ready(function() {
    $(".hashtag_inputs").on("change", function() {
        $("#hashtag").text("#" + this.value);
    });
})
