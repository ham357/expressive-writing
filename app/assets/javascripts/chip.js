$(document).ready(function () {

  var tag_list = $('#post_draft_tag_list');
  var tagListVal = $('#post_draft_tag_list').val();

  var allTags = gon.tags;
  var allTagdata = {}
  allTags.map( function(value,i) {
    allTagdata[value.name] = null;
  });
  
  var tagListArray = tagListVal.split(',');
  var userTagData = [];
  tagListArray.map( function(value,i) {
    userTagData[i] = {tag: value};
});

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
    onChipDelete: chipDeleteCallback,
    autocompleteOptions: {
      data: allTagdata,
      limit: Infinity,
      minLength: 1
    }
  });
});
