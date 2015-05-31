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

# Plural

  plural_count = $('#PluralForm .answers').data('count')-1 || 0

  $('.add-plural').on 'click', ->
    plural_count++
    template = $('#plural-prototype').clone(true)
    template.removeAttr('id')
    template.addClass('answer')
    template.attr('data-number', plural_count)
    template.removeClass('hidden')
    check = template.find('span input[type="checkbox"]')
    check_hidden = template.find('span input[type="hidden"]')
    text = template.children('input')
    check.attr('name', "question[plurals_attributes][#{plural_count}][is_right]")
    check.attr('id', "question_plurals_attributes_#{plural_count}_is_right")
    check_hidden.attr('name', "question[plurals_attributes][#{plural_count}][is_right]")
    check_hidden.attr('name', "question[plurals_attributes][#{plural_count}][is_right]")
    text.attr('name', "question[plurals_attributes][#{plural_count}][text]")
    text.attr('id', "question_plurals_attributes_#{plural_count}_text")
    $('#PluralForm .answers').append(template)

  $('.del-plural').on 'click', ->
    if plural_count != 0
      if $("#PluralForm .answer[data-number = '#{plural_count}']").length != 0
        $("#PluralForm .answer[data-number = '#{plural_count}']").remove()
      else
        flag = $('#rm-flag-prototype').children().clone(true)
        flag.attr('name', "question[plurals_attributes][#{plural_count}][_destroy]")
        $("input[name='question[plurals_attributes][#{plural_count}][text]'").parent().append(flag)
        $("input[name='question[plurals_attributes][#{plural_count}][text]'").parent().addClass('hidden')
      plural_count--

# Associative
  associative_count = $('#AssociativeForm .answers').data('count')-1 || 0

  $('.add-associative').on 'click', ->
    associative_count++
    template = $('#associative-prototype').clone(true)
    template.removeAttr('id')
    template.addClass('associative')
    template.attr('data-number', associative_count)
    template.removeClass('hidden')
    left_text = template.find('input[data-side="left"]')
    right_text = template.find('input[data-side="right"]')
    left_text.attr('name', "question[associations_attributes][#{associative_count}][left_text]")
    left_text.attr('id', "question_associations_attributes_#{associative_count}_left_text")
    right_text.attr('name', "question[associations_attributes][#{associative_count}][right_text]")
    right_text.attr('id', "question_associations_attributes_#{associative_count}_right_text")
    $('#AssociativeForm .answers').prepend(template)
    false

  $('.del-associative').on 'click', ->
    if associative_count != 0
      if $("#AssociativeForm .associative[data-number='#{associative_count}']").length != 0
        $("#AssociativeForm .associative[data-number='#{associative_count}']").remove()
      else
        flag = $('#rm-flag-prototype').children().clone(true)
        flag.attr('name', "question[associations_attributes][#{associative_count}][_destroy]")
        $("input[name='question[associations_attributes][#{associative_count}][left_text]'").parents('.associative').append(flag)
        $("input[name='question[associations_attributes][#{associative_count}][left_text]'").parents('.associative').addClass('hidden')
      associative_count--
    false

  $('.chain-locker').on 'click', ->
    if $(this).data('locked') == 'yes'
      $(this).children('.fa-chain').addClass('fa-chain-broken')
      $(this).children('.fa-chain').removeClass('fa-chain')
      left_item = $(this).parents('.associative').find('.answer-right input')
      left_item.val('')
      left_item.addClass('hidden')
      $(this).data('locked', 'no')
    else
      $(this).children('.fa-chain-broken').addClass('fa-chain')
      $(this).children('.fa-chain-broken').removeClass('fa-chain-broken')
      $(this).parents('.associative').find('.answer-right input').removeClass('hidden')
      $(this).data('locked', 'yes')
    false
