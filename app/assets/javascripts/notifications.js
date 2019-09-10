$(function(){
  $(document).on("click", ".notifications", function (e) {
    e.preventDefault();
    setTimeout(function() {
      $(".notifications-contents").css("visibility", "visible");
    }, 200);
  });

  $(document).on("click",function(e) {
    if ($(".notifications-contents").is(':visible')) {
      $(".notifications-contents").css("visibility", "hidden");
    }
  });

  var iframe_height = $('.notifications-body').outerHeight(true);
  $('iframe', parent.document).css('height', iframe_height + 'px');
});
