$(document).ready(function () {
  if ( location.pathname.match(/edit/) || location.pathname.match(/new/)){
  var tagList = $('#post_draft_tag_list');

  var allTags = typeof gon.tags !== 'undefined' ? gon.tags : [];
  var allTagdata = {};
  allTags.map( function(value,i) {
    allTagdata[value.name] = null;
  });
    var userTags = typeof gon.user_tags !== 'undefined' ? gon.user_tags : [];
    var userTagData = [];
    userTags.map( function(value,i) {
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
      $('#tag-input').attr('placeholder', '+Tag(5つまで)');
    }
    tagListUpdate(instance);
  }

  $('.chips').chips({
    data: userTagData,
    placeholder: 'Enter + tag(5つまで)',
    secondaryPlaceholder: '+Tag(5つまで)',
    limit: 5,
    onChipAdd: chipAddCallback,
    onChipDelete: chipDeleteCallback,
    autocompleteOptions: {
      data: allTagdata,
      limit: Infinity,
      minLength: 1
    }
  });
}
});
