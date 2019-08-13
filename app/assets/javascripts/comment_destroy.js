$(function() {
  $(document).on("click", ".commnet-destroy", function (e) {
    e.preventDefault();
    var deleteConfirm = confirm('削除してよろしいでしょうか？');
    if(deleteConfirm == true) {
      var comment_section = $('#comment-section');
      var comment_element = $(this).parents('.comment');
      var comment_id = comment_element.attr("data-comment_id");
      var url = location.href + "/comments/" + comment_id;

      $.ajax({
      url: url,
      type: "POST",
      data: {'id': comment_id,
      '_method': 'DELETE'} ,
      dataType: 'json'
    })
    .done(function(data) {
      if ($('.comment').length == 1){
        comment_section.remove();
      }else{
        comment_element.remove();
      }
    })
    
    .fail(function() {
      alert('comment destroy error');
    })
  }
  });
});
