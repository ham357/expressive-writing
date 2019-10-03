$(document).ready(function () {
  $('.chips').chips();

  $('.chips-placeholder').chips({
    placeholder: 'Enter a tag',
    secondaryPlaceholder: '+Tag',
    limit: 5
  });
});
