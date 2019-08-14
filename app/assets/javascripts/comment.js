$(function() {
  
  function buildHTML(comment){
    var html = `
    <ul class="comment" data-comment_id="${comment.id}">
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

    if ($("#comment-section").length == 0){
      html = `<li class="collection-item avatar" id="comment-section">`
      + html
      + `</li>`
      $('#comment-form-section').before(html);
    }else{
      $('#comment-section').append(html)
    }
  }
  $('#new_comment').on('submit', function(e){
    e.preventDefault();
    var formData = new FormData(this);
    var url = $(this).attr('action')
    $.ajax({
      url: url,
      type: "POST",
      data: formData,
      dataType: 'json',
      processData: false,
      contentType: false
    })
    .done(function(data){
      buildHTML(data);
      $('.textbox').val('')
      $('.comment_submit-btn').addClass('disabled');
      $('#comment-section').animate({scrollTop:$("#comment-section")[0].scrollHeight});
    });
  });
});
