var ready = function () {
  // submit search on enter
  $('input.keyword-box').keypress(function (e) {
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
};

$(document).ready(ready);
$(document).on('page:change', ready);
