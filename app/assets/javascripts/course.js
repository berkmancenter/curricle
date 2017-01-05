$(document).ready( function () {
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
    prefix: 'Term: '
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
});
