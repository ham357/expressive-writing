$(function() {
  var min_comment_length = 1;
  var max_comment_length = 250;

  $(document).on('keyup', $(".comment-textbox"), function () {
    var txt = $(".comment-textbox").val();
    new_txt = $.trim(txt.replace(/\n/g, ""));
    comment_length_count = new_txt.length;

    if (comment_length_count < min_comment_length|| comment_length_count > max_comment_length){
      $('.comment_submit-btn').addClass('disabled');
    }else{
      $('.comment_submit-btn').removeClass('disabled');
    }
    });

  $(document).on('keyup', $(".comment__InlineEdit-input"), function () {
    var txt = $(".comment__InlineEdit-input").val();
    new_txt = $.trim(txt.replace(/\n/g, ""));
    comment_length_count = new_txt.length;

    if (comment_length_count < min_comment_length|| comment_length_count > max_comment_length){
      $('.comment__InlineEdit-save').addClass('disabled');
    }else{
      $('.comment__InlineEdit-save').removeClass('disabled');
    }
    });
});__
