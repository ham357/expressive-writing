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
      var commentsCount = Number($('#comment-section__comments-count').attr("data-comments_count")) - 1;
      $('#comment-section__comments-count').text("コメント"+commentsCount+"件");
    })
    
    .fail(function() {
      alert('comment destroy error');
    })
  }
  });
});
