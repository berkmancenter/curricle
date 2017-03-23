var ready = function () {
  // submit search on enter
  $('.search-form').on('keypress', 'input.keyword-box', function (e) {
    if (e.which == '13') {
      $(this).closest('form').submit();
    }
  });

  // submit reset form
  $('.reset-link').click(function (e) {
    e.preventDefault();
    $(this).closest('form').submit();
  });

  $('select.multiple.dropdown').multiselect({
    placeholder: '',
    minHeight: null,
    showCheckbox: false,
    prefix: 'Apply to: '
  });

  $('select.single.dropdown').multiselect({
    placeholder: '',
    minHeight: null,
    showCheckbox: false,
    multiple: false
  });

  $('select.term-select.dropdown').multiselect({
    placeholder: '',
    minHeight: null,
    showCheckbox: false,
    multiple: false,
    prefix: 'Term: ',
    onOptionClick: function (select) {
      if (typeof setVisibilityBySemester === "function") {
        setVisibilityBySemester();
      }
    }
  });

  $('select.school-select.dropdown').multiselect({
    placeholder: '',
    minHeight: null,
    showCheckbox: false,
    multiple: false,
    prefix: 'School: '
  });

  $('select.department-select.dropdown').multiselect({
    placeholder: '',
    minHeight: null,
    showCheckbox: false,
    multiple: false,
    prefix: 'Department: ',
    search: true
  });

  $('select.subject-select.dropdown').multiselect({
    placeholder: '',
    minHeight: null,
    showCheckbox: false,
    multiple: false,
    prefix: 'Subject: ',
    search: true
  });

  $('select.type-select.dropdown').multiselect({
    placeholder: '',
    minHeight: null,
    showCheckbox: false,
    multiple: false,
    prefix: 'Type: ',
    search: true
  });

  // handle add new search keyword
  $('button.add-keywords').click(function (e) {
    e.preventDefault();

    var template = $('.keywords-wrapper .box').last();
    var box = template.clone();
    var newIndex = box.data('index') + 1;

    // setup text box
    box.find('.keyword-box').val('').attr('name', 'keywords[' + newIndex + ']');
    box.find('.keyword-weights-box').val('').attr('name', 'keyword_weights[' + newIndex + ']');

    // setup multiselect
    box.find('.ms-options-wrap').remove();
    box.find('select').val(['title', 'description']).attr('name', 'keyword_options[' + newIndex + '][]').removeClass('jqmsLoaded').multiselect({
      placeholder: '',
      minHeight: null,
      showCheckbox: false,
      prefix: 'Apply to: '
    });

    // add to dom
    template.closest('.keywords-wrapper').append(box);

    // give focus
    box.find('.keyword-box').focus();
  });

  // handle remove search keyword
  $('.keywords-wrapper').on('click', '.box .remove', function (e) {
    e.preventDefault();

    if ($('.keywords-wrapper .box').length > 1) {
      $(this).closest('.box').remove();
    }
  });
};

$(document).ready(ready);
$(document).on('page:change', ready);
