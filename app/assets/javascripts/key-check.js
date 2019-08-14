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

  $(document).on('keyup', $(".comment__inlineEdit-input"), function () {
    var txtBoxValue = $(".comment__inlineEdit-input").val();
    var fixTxtBoxValue = $.trim(txtBoxValue.replace(/\n/g, ""));
    var commentLengthCount = fixTxtBoxValue.length;

    if (commentLengthCount < minCommentLength|| commentLengthCount > maxCommentLength){
      $('.comment__inlineEdit-save').addClass('disabled');
    }else{
      $('.comment__inlineEdit-save').removeClass('disabled');
    }
    });
});
