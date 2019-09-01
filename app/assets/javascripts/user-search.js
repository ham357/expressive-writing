$(function(){
  var search_result = $("#user-search-result");
  var textField = $("#user-search-field");
  var preWord = "";

   function appendErrMsgToHTML(msg) {
    var html = `<div><p>${ msg }</p></div>`
    
    search_result.append(html);
  }

  textField.on("keyup", function () {
      var input = textField.val();
      var Word = input;
      
      if (Word !== preWord){
        $.ajax({
          type: 'GET',
          url: '/users',
          data: { keyword: input },
          dataType: 'script'
        })
    
        .done(function(){
          if ($("#user-search-result").text() == ""){
            appendErrMsgToHTML("一致するユーザーはいません");
          }
        })
        .fail(function(){
          alert('ユーザー検索に失敗しました');
        })
      }
      preWord = Word;
    });
  });
