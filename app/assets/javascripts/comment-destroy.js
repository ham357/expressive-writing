$(function() {
  $(document).on("click", ".commnet-destroy", function (e) {
    e.preventDefault();
    var deleteConfirm = confirm('削除してよろしいでしょうか？');
    if(deleteConfirm == true) {
      var commentSection = $('#comment-section');
      var commentElement = $(this).parents('.comment');
      var commentId = commentElement.attr("data-comment_id");
      var url = location.href + "/comments/" + commentId;

      $.ajax({
      url: url,
      type: "POST",
      data: {'id': commentId,
      '_method': 'DELETE'} ,
      dataType: 'json'
    })
    .done(function(data) {
      if ($('.comment').length == 1){
        commentSection.remove();
      }else{
        commentElement.remove();
      }
    })
    
    .fail(function() {
      alert('comment destroy error');
    })
  }
  });
});
