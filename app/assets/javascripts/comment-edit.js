$(function() {
  var inlineEdit;
  var values = {
    id: "",
    name: "",
    created_at: "",
    comment: "",
    image:""
  }
  
  function reBuild(comment) {
    var html = `
    <li>
    <img class="circle responsive-img" id="comment-section__image" src="${comment.user_image}">
    <span class="title">
    <div id="comment-section__name">${comment.user_name}</div>
    <div id="comment-section__comment">${comment.comment}</div>
    </span>
    <div class="action">
    <a class="commnet-edit" href=""><i class="material-icons">edit</i></a>
    <a class="commnet-destroy" href=""><i class="material-icons">delete</i></a>
    </div>
    </li>
    </ul>`

  inlineEdit.removeClass('comment-edit_acitve').empty().append(html);
  $(".action").css("visibility", "visible");
  }  
  $(document).on("click", ".comment-edit-cancelbtn", function () {
    reBuild(values);  
  });

  $(document).on("click", ".comment-edit-savebtn", function () {

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
      user_image: inlineEdit.find('#comment-section__image').attr("src"),
      user_name: inlineEdit.find('#comment-section__name').text(),
      comment: inlineEdit.find('#comment-section__comment').text()
    }
    var input_element = '<li><img class="circle responsive-img" id="comment-section__image" src="'+values.user_image+'"><input class="comment-edit-textbox" type="text" value="'+values.comment+'"></li>';
      var button_element = '<div class="btn waves-effect waves-light grey comment-edit-cancelbtn"><i class="material-icons">clear</i></div><button class="btn waves-effect waves-light comment-edit-savebtn" name="action" type="submit"><i class="material-icons">check</i></button>';
      inlineEdit.addClass('comment-edit_acitve').empty().append(input_element).append(button_element).find('input').focus();
  });
});