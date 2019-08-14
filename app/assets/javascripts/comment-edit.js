$(function() {
  var inlineEdit;
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

  inlineEdit.removeClass('comment-edit_acitve').empty().append(html);
  $(".action").css("visibility", "visible");
  }  
  $(document).on("click", ".comment__inlineEdit-cancel", function () {
    reBuild(values);  
  });

  $(document).on("click", ".comment__inlineEdit-save", function () {

    var url = location.href + "/comments/" + values.id;
    var input = inlineEdit.find('input').val();

      $.ajax({
        url: url,
        type: "POST",
        data: {'id': values.id,
        'comment': input,
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
    inlineEdit = $(this).parents('.comment');
    $(".action").css("visibility", "hidden");
    values = {
      id: inlineEdit.attr("data-comment_id"),
      image: inlineEdit.find('#comment-section__image').attr("src"),
      name: inlineEdit.find('#comment-section__name').text(),
      comment: inlineEdit.find('#comment-section__comment').text()
    }
    var input_element = '<li><img class="circle responsive-img" id="comment-section__image" src="'+values.image+'"><input class="comment__inlineEdit-input" type="text" value="'+values.comment+'"></li>';
      var button_element = '<div class="btn waves-effect waves-light grey comment__inlineEdit-cancel">キャンセル<i class="material-icons right">cancel</i></div><button class="btn waves-effect waves-light comment__inlineEdit-save" name="action" type="submit">更新<i class="material-icons right">send</i></button>';
      inlineEdit.addClass('comment-edit_acitve').empty().append(input_element).append(button_element).find('input').focus();
  });
});