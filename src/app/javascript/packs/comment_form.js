$(document).on("turbolinks:load", function () {
  $(function () {
    $(".comment_btn").on("click", function () {
      $(".is-open").slideToggle();
    });
  });
});
