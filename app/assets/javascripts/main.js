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

  /* question change type */
  $('.change-type').click(function(){
    var text = '';
    switch($(this).data('question-type')){
      case 1:
        text = 'Logical';
        $('#logical-form')[0].className = '';
        $('#plural-form')[0].className = 'hidden';
        $('#many-to-many-form')[0].className = 'hidden';
        break;
      case 2:
        text = 'Plural';
        $('#logical-form')[0].className = 'hidden';
        $('#plural-form')[0].className = '';
        $('#many-to-many-form')[0].className = 'hidden';
        break;
      case 3:
        text = 'Many to Many';
        $('#logical-form')[0].className = 'hidden';
        $('#plural-form')[0].className = 'hidden';
        $('#many-to-many-form')[0].className = '';
        break;
    }
    $('#question_question_type')[0].value = $(this).data('question-type');
    $('#question-type')[0].textContent = text;
    return false
  });

  /* plural answers operations */
  var $answers_count = 0;

  $('.add-plural').click( function(){
    var answers = $('#plural-answers');
    if ($answers_count == 0)
      $answers_count = answers.data('count');
    $answers_count++;
    var new_input_group = document.createElement('div');
    new_input_group.className = 'form-group input-group number'+$answers_count;
      var new_span = document.createElement('span');
      new_span.className = 'input-group-addon';
        var new_answer_check_input = document.createElement('input');
        new_answer_check_input.setAttribute('type', 'checkbox');
        new_answer_check_input.setAttribute('name', 'plural_answers[new'+$answers_count+'[is_right]]]');
      var new_answer_text_input = document.createElement('input');
      new_answer_text_input.setAttribute('type', 'text');
      new_answer_text_input.setAttribute('name', 'plural_answers[new'+$answers_count+'[text]]]');
      new_answer_text_input.className = 'form-control default';
    new_span.appendChild(new_answer_check_input);
    new_input_group.appendChild(new_span);
    new_input_group.appendChild(new_answer_text_input);

    answers.append(new_input_group);
  });

  $(".del-plural").click(function() {
    if ($answers_count != 0){
      $('.number' + $answers_count).remove();
      $answers_count--;
    }
  });
};

$(document).ready(ready);
$(document).on('page:load', ready);
