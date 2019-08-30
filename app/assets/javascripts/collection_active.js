$(document).ready(function () {

    if($(".collection.left .collection-item").length){
      $('.collection.left .collection-item').each(function(){
        var $href = $(this).attr('href');
        if(location.pathname == $href) {
        $(this).addClass('active');
        } else {
        $(this).removeClass('active');
        }
      });
    };
  
});
