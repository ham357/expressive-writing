$(function() {
  
  function buildHTML(comment){
    var html = `
    <ul class="comment" data-comment_id="${comment.id}">
    <li>
    <img class="circle responsive-img" src="${comment.user_image}">
    <span class="title">
    ${comment.user_name}
    <br>
    ${comment.comment}
    </span>
    <div class="action">
    <a data-turbolinks="false" href="">編集する</a>
    <a class="commnet-destroy" href="">削除する</a>
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
    });
  });
});
