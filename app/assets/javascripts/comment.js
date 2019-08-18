$(function() {
  
  function buildHTML(comment){
    var html = `
    <ul class="comment" data-comment_id="${comment.id}">
    <li>
    <img class="circle responsive-img" id="comment-section__image" src="${comment.user_image}">
    <span class="title">
    <div id="comment-section__name">${comment.user_name}</div>
    <div id="comment-section__comment">${comment.comment}</div>
    <p class="grey-text" id="comment-section__createtime">たった今</p>
    </span>
    <ul id="icon-section">
    <li class="like-link" id="comment-like-link-${comment.id}">
    <a data-remote="true" rel="nofollow" data-method="post" href="/comment_like/${comment.id}"><i class="hoverable material-icons" id="comment-heart-${comment.id}">favorite_border</i>0</a></li>
    <li class="action" id="edit-del-links" style="visibility: visible;">
    <a class="comment-edit" href=""><i class="hoverable material-icons">edit</i>
    </a><a class="comment-destroy" href=""><i class="hoverable material-icons">delete</i>
    </a></li>
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
      var commentsCount = Number($('#comment-section__comments-count').attr("data-comments_count")) + 1;
      $('#comment-section__comments-count').text("コメント"+commentsCount+"件");
      $('#comment-section').animate({scrollTop:$("#comment-section")[0].scrollHeight});
    });
  });
});
