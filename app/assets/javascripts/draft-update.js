$(document).ready(function () {
  var preTitleWord = ""
  var nowTitleWord = ""
  var preContentsWord = ""
  var nowContentsWord = ""

  $(document).on('keyup', $("#post_draft_title"), function (e) {
    if($("#post_draft_title").length){
      nowTitleWord = $("#post_draft_title").val();

      setTimeout(function() {
        if(preTitleWord !== nowTitleWord){
          $("form").attr("data-remote","true")
          $('#draft-btn').trigger('click');
          $("form").attr("data-remote","false")
          M.toast({html: '自動保存しました'})
          preTitleWord = nowTitleWord;
        }
      }, 3000);
    };
  });

  $(document).on('keyup', $("#post_draft_contents"), function (e) {
    if($("#post_draft_contents").length){
      nowContentsWord = $("#post_draft_contents").val();

      setTimeout(function() {
        if(preContentsWord !== nowContentsWord){
          $("form").attr("data-remote","true")
          $('#draft-btn').trigger('click');
          $("form").attr("data-remote","false")
          M.toast({html: '自動保存しました'})
          preContentsWord = nowContentsWord;
        }
      }, 3000);
    };
  });

});
