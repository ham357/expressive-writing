$(document).ready(function () {
  var preTitleWord = ""
  var nowTitleWord = ""
  var preContentsWord = ""
  var nowContentsWord = ""
  var timer = false;
  
  function autoPostDraftSave() {
    $("form").attr("data-remote","true");
    $('#draft-btn').trigger('click');
    $("form").attr("data-remote","false");
    M.toast({html: '自動保存しました'});
  }

  $("#post_draft_title").on('keyup', function (e) {
    if($("#post_draft_title").length){
      nowTitleWord = $("#post_draft_title").val();
      if (timer != false)  clearTimeout(timer);
      timer = setTimeout(function() {
        if(preTitleWord !== nowTitleWord){
          autoPostDraftSave();
          preTitleWord = nowTitleWord;
        }
      }, 3000);
    };
  });

  $("#post_draft_contents").on('keyup', function (e) {
    if($("#post_draft_contents").length){
      nowContentsWord = $("#post_draft_contents").val();
      if (timer != false)  clearTimeout(timer);
      timer = setTimeout(function() {
        if(preContentsWord !== nowContentsWord){
          autoPostDraftSave();
          preContentsWord = nowContentsWord;
        }
      }, 3000);
    };
  });
});
