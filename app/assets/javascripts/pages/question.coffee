$ ->
# Change question type
  $('.change-type').on 'click', ->
    header = $('#QuestionType:first')
    switch $(this).data('question-type')
      when 1
        text = header.data('logical')
        $('#LogicalForm').removeClass('hidden')
        $('#PluralForm').addClass('hidden')
        $('#AssociativeForm').addClass('hidden')
        break;
      when 2
        text = header.data('plural')
        $('#LogicalForm').addClass('hidden')
        $('#PluralForm').removeClass('hidden')
        $('#AssociativeForm').addClass('hidden')
        break;
      when 3
        text = header.data('manytomany')
        $('#LogicalForm').addClass('hidden')
        $('#PluralForm').addClass('hidden')
        $('#AssociativeForm').removeClass('hidden')
        break;

    $('#question_question_type').val($(this).data('question-type'))
    $('#QuestionType').html(text)
    false

#  Plural
  plural_count = 0

  $('.add-plural').on 'click', ->
    answers = $('#plural-answers')
    plural_count = answers.data('count')-1 if plural_count == 0
    plural_count++
    template = $('#plural-prototype').clone(true)
    template.removeAttr('id')
    template.addClass("answer#{plural_count}")
    template.removeClass('hidden')
    check = template.find('span input[type="checkbox"]')
    check_hidden = template.find('span input[type="hidden"]')
    text = template.children('input')
    check.attr('name', "question[answer2s_attributes][#{plural_count}][is_right]")
    check.attr('id', "question_answer2s_attributes_#{plural_count}_is_right")
    check_hidden.attr('name', "question[answer2s_attributes][#{plural_count}][is_right]")
    check_hidden.attr('name', "question[answer2s_attributes][#{plural_count}][is_right]")
    text.attr('name', "question[answer2s_attributes][#{plural_count}][text]")
    text.attr('id', "question_answer2s_attributes_#{plural_count}_text")
    $('#plural-answers').append(template)

  $('.del-plural').on 'click', ->
    if plural_count != 0
      $(".answer#{plural_count}").remove()
      plural_count--

#  Associative
  left_count = 1
  right_count = 1

  add_associative = (side) ->
    count = if side == 'left' then left_count++ else right_count++
    count++
    input = document.createElement('input')
    input.setAttribute('type', 'text')
    input.className = 'form-control'
    input.setAttribute('name', "plural_answers[#{side}[#{count}[text]]]")
    input.setAttribute('id', "plural_answers[#{side}[#{count}[text]]]")
    $('.answers-'+side+' .form-group')[0].appendChild(input)

  $('.add-many-left').on 'click', ->
    add_associative('left')
    false

  $('.del-many-left').on 'click', ->
    if left_count > 1
      document.getElementById("plural_answers[left[#{left_count}[text]]]").remove()
      left_count--
    false

  $('.add-many-right').on 'click', ->
    add_associative('right')
    false

  $('.del-many-right').on 'click', ->
    if right_count > 1
      document.getElementById("plural_answers[right[#{right_count}[text]]]").remove()
      right_count--
    false
