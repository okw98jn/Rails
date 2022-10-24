$(document).on("turbolinks:load", function () {
  $(function () {
    $(".tab").on("click", function () {
      $(".tab").removeClass("post_tab_active");
      $(".post_content").removeClass("content_active");

      $(this).addClass("post_tab_active");

      const index = $(".tab").index(this);
      $(".post_content").eq(index).addClass("content_active");
    });
  });
});
