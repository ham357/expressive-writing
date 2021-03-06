$(function() {
  var inlineEdit;
  var values = {
    id: "",
    name: "",
    created_at: "",
    comment: "",
    image:""
  }
  var iconSection;
  var editedComment = "";

  function reBuild(comment) {
    var html = `
    <li>
    <img class="circle responsive-img" id="comment-section__image" src="${comment.user_image}">
    <span class="title">
    <div id="comment-section__name">${comment.user_name}</div>
    <div id="comment-section__comment">${comment.comment}</div>
    <div class="grey-text" id="comment-section__updated-comment">` + editedComment + `</div>
    <p class="grey-text" id="comment-section__createtime">${values.created_at}</p>
    </span>
    </li>`

  inlineEdit.removeClass('comment-edit_acitve').empty().append(html);
  inlineEdit.find('li').append(iconSection);
  $(".action").css("visibility", "visible");
  editedComment = "";
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
        editedComment = "(編集済み)" 
        reBuild(data);
      })
      
      .fail(function() {
        alert('message edit error');
      })
    
  });
  $(document).on("click", ".comment-edit", function (e) {
    e.preventDefault();
    inlineEdit = $(this).parents('.comment');
    iconSection = inlineEdit.find("#icon-section").clone();
    $(".action").css("visibility", "hidden");
    values = {
      id: inlineEdit.attr("data-comment_id"),
      user_image: inlineEdit.find('#comment-section__image').attr("src"),
      user_name: inlineEdit.find('#comment-section__name').text(),
      comment: inlineEdit.find('#comment-section__comment').text(),
      created_at: inlineEdit.find('#comment-section__createtime').text()
    }
    
    var input_element = '<li><img class="circle responsive-img" id="comment-section__image" src="'+values.user_image+'"><input class="comment-edit-textbox"  id="comment-edit-textbox" type="text" value="'+values.comment+'"></li>';
      var button_element = '<div class="btn waves-effect waves-light grey comment-edit-cancelbtn"><i class="material-icons">clear</i></div><button class="btn waves-effect waves-light comment-edit-savebtn" name="action" type="submit"><i class="material-icons">check</i></button>';
      inlineEdit.addClass('comment-edit_acitve').empty().append(input_element).append(button_element).find('input').focus();
  });
});