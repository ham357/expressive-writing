$(function() {
  var InlineEdit;
  var values = {
    id: "",
    name: "",
    created_at: "",
    content: "",
    image:""
  }
  
  function reBuild(comment) {
    var html = `
    <li>
    <img class="circle responsive-img" id="comment-section__image" src="${comment.image}">
    <span class="title">
    <div id="comment-section__name">${comment.name}</div>
    <div id="comment-section__comment">${comment.comment}</div>
    </span>
    <div class="action">
    <a class="commnet-edit" href="">編集する</a>
    <a class="commnet-destroy" href="">削除する</a>
    </div>
    </li>
    </ul>`

  InlineEdit.removeClass('InlineEdit-active').empty().append(html);
  $("#edit-del-links").show();
  }  
  $(document).on("click", ".comment__InlineEdit-cancel", function () {
    reBuild(values);  
  });

  $(document).on("click", ".comment__InlineEdit-save", function () {

    var url = location.href + "/comments/" + values.id;
    var input = InlineEdit.find('input').val();

      $.ajax({
        url: url,
        type: "POST",
        data: {'id': values.id,
        'content': input,
        '_method': 'PATCH'} ,
        dataType: 'json'
      })
      .done(function(data) {
        reBuild(data);
      })
      
      .fail(function() {
        alert('message edit error');
      })
    
  });
  $(document).on("click", ".commnet-edit", function (e) {
    e.preventDefault();
    InlineEdit = $(this).parents('.comment');
    $("#edit-del-links").hide();
    values = {
      id: InlineEdit.attr("data-comment_id"),
      image: InlineEdit.find('#comment-section__image').attr("src"),
      name: InlineEdit.find('#comment-section__name').text(),
      comment: InlineEdit.find('#comment-section__comment').text()
    }
    console.log(values);
    var input_element = '<li><img class="circle responsive-img" id="comment-section__image" src="'+values.image+'"><input class="comment__InlineEdit-input" type="text" value="'+values.comment+'"></li>';
      var button_element = '<div class="btn waves-effect waves-light grey comment__InlineEdit-cancel">キャンセル<i class="material-icons right">cancel</i></div><button class="btn waves-effect waves-light comment__InlineEdit-save" name="action" type="submit">更新<i class="material-icons right">send</i></button>';
      InlineEdit.addClass('InlineEdit-active').empty().append(input_element).append(button_element).find('input').focus();
  });
});