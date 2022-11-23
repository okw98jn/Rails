$(document).on("turbolinks:load", function () {
  const ham = $("#js-hamburger");
  const nav = $("#js-nav");
  ham.on("click", function () {
    ham.toggleClass("active"); 
    nav.toggleClass("active");
  });
});
