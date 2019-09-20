$(function() {
  
  function buildHTML(title,urlParam){
    var urlHost = location.host;
    var url = "http://" + urlHost + urlParam
    var hashtag = "ExpressiveWriting";
    var html = `<h4>SNSでシェアする</h4>
    <a href="http://twitter.com/share?text=${title}&url=${url}&hashtags=${hashtag}" class="twitter_btn" target=”_blank>
    <i class="fab fa-twitter-square fa-3x twitter-color"></i></a>
    <a href="https://www.facebook.com/sharer/sharer.php?u=${url}" class="facebook_btn" target=”_blank>
    <i class="fab fa-facebook-square fa-3x facebook-color"></i></a>
    <a href="http://line.me/R/msg/text/?${url}" class="line_btn" target=”_blank><i class="fab fa-line fa-3x line-color"></i></a>`

      $('.modal-content').append(html)
  }
  $('.modal-trigger').on('click', function(){
    var title = $(this).parents(".card-content").find("#card-title").text();
    var urlParam = $(this).parents(".card-content").find("#card-url a").attr("href");
    $(".modal-content").empty();
    buildHTML(title,urlParam);
  });

  $(document).ready(function(){
		$('.modal').modal();
	});
});
