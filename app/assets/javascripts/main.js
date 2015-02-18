/**
 * Created by kris on 24.11.14.
 */

ready = function(){
  /* code invite button */

  $(".btn.btn-warning.key-gen").click(function() {
    $.getJSON('/invite_code', function (result) {
      $('#admin_token').text('Admin: '+result.admin);
      $('#user_token').text('User: '+result.user);
    });
  });

  /* mark operations button */
  var $marks_count = 0;

  $(".add-mark").click(function() {
    var marks = $('#marks');
    if ($marks_count == 0)
      $marks_count = marks.data('count');
    $marks_count++;
    var new_form_group = document.createElement('div');
    new_form_group.className = 'form-group number'+$marks_count;
    var presentation_col = document.createElement('div');
    presentation_col.className = 'col-lg-6';
    var new_presentation_input = document.createElement('input');
    new_presentation_input.setAttribute('type', 'text');
    new_presentation_input.setAttribute('name', 'mark_system[marks[new'+$marks_count+'[presentation]]]');
    new_presentation_input.className = 'form-control';
    presentation_col.appendChild(new_presentation_input);
    var percent_col = document.createElement('div');
    percent_col.className = 'col-lg-6';
    var new_percent_input = document.createElement('input');
    new_percent_input.setAttribute('type', 'text');
    new_percent_input.setAttribute('name', 'mark_system[marks[new'+$marks_count+'[percent]]]');
    new_percent_input.className = 'form-control';
    percent_col.appendChild(new_percent_input);
    new_form_group.appendChild(presentation_col);
    new_form_group.appendChild(percent_col);

    marks.append(new_form_group);
  });

  $(".del-mark").click(function() {
    if ($marks_count != 0){
      $('.number' + $marks_count).remove();
      $marks_count--;
    }
  });
};

$(document).ready(ready);
$(document).on('page:load', ready);
