$(document).ready(function () {

  var tag_list = $('#post_draft_tag_list');


  function tagListUpdate() {
    var instance = $('.chips').chips('getData');

    var result = instance.map( function(value) {
          return value.tag;
      });
    tag_list.val(result.join(','));
  }

  function chipAddCallback() {
    tagListUpdate();
  };

  function chipDeleteCallback() {
    tagListUpdate();
  }

  $('.chips').chips({
    data: userTagData,
    placeholder: 'Enter a tag',
    secondaryPlaceholder: '+Tag',
    limit: 5,
    onChipAdd: chipAddCallback,
    onChipDelete: chipDeleteCallback
  });
});
