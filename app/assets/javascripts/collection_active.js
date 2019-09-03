$(document).ready(function () {

    if($(".collection .collection-item").length){
      $('.collection .collection-item').each(function(){
        var $href = $(this).attr('href');
        if(location.pathname == $href) {
        $(this).addClass('active');
        } else {
        $(this).removeClass('active');
        }
      });
    };
  
});
