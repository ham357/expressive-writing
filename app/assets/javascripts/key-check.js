$(function() {
  var minCommentLength = 1;
  var maxCommentLength = 250;

  $(document).on('keyup', $(".comment-textbox"), function () {
    var txtBoxValue = $(".comment-textbox").val();
    var fixTxtBoxValue = $.trim(txtBoxValue.replace(/\n/g, ""));
    var commentLengthCount = fixTxtBoxValue.length;

    if (commentLengthCount < minCommentLength|| commentLengthCount > maxCommentLength){
      $('.comment_submit-btn').addClass('disabled');
    }else{
      $('.comment_submit-btn').removeClass('disabled');
    }
    });

  $(document).on('keyup', $(".comment-edit-textbox"), function () {
    var txtBoxValue = $(".comment-edit-textbox").val();
    var fixTxtBoxValue = $.trim(txtBoxValue.replace(/\n/g, ""));
    var commentLengthCount = fixTxtBoxValue.length;

    if (commentLengthCount < minCommentLength|| commentLengthCount > maxCommentLength){
      $('.comment-edit-savebtn').addClass('disabled');
    }else{
      $('.comment-edit-savebtn').removeClass('disabled');
    }
    });
});
