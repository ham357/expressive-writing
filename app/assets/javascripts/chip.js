$(document).ready(function () {

  var tagList = $('#post_draft_tag_list');
  var tagListVal = $('#post_draft_tag_list').val();

  var allTags = gon.tags;
  var allTagdata = {}
  allTags.map( function(value,i) {
    allTagdata[value.name] = null;
  });
  var user_tags = gon.user_tags;
  var userTagData = [];
  user_tags.map( function(value,i) {
    userTagData[i] = {tag: value};
});

  function tagListUpdate(instance) {
    var result = instance.map( function(value) {
          return value.tag;
      });
    tagList.val(result.join(','));
  }

  function chipAddCallback() {
    var instance = $('.chips').chips('getData');
    if (instance.length == 5){
      $('#tag-input').removeAttr('placeholder');
    }
    tagListUpdate(instance);
  };

  function chipDeleteCallback() {
    var instance = $('.chips').chips('getData');
    if (instance.length == 4){
      $('#tag-input').attr('placeholder', '+Tag');
    }
    tagListUpdate(instance);
  }

  $('.chips').chips({
    data: userTagData,
    placeholder: 'Enter a tag',
    secondaryPlaceholder: '+Tag',
    limit: 5,
    onChipAdd: chipAddCallback,
    onChipDelete: chipDeleteCallback,
    autocompleteOptions: {
      data: allTagdata,
      limit: Infinity,
      minLength: 1
    }
  });
});
