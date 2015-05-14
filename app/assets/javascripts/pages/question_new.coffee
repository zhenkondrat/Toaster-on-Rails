$ ->
  left_count = 1
  right_count = 1

  $('.add-many-left').on 'click', ->
    left_count++
    input = document.createElement('input')
    input.setAttribute('type', 'text')
    $(input).addClass('form-control')
    input.setAttribute('name', "plural_answers[left[#{left_count}[text]]]")
    input.setAttribute('id', "plural_answers[left[#{left_count}[text]]]")
    $('.answers-left')[0].appendChild(input)
    false

  $('.del-many-left').on 'click', ->
    if left_count > 1
      document.getElementById("plural_answers[left[#{left_count}[text]]]").remove()
      left_count--
    false

  $('.add-many-right').on 'click', ->
    right_count++
    input = document.createElement('input')
    input.setAttribute('type', 'text')
    $(input).addClass('form-control')
    input.setAttribute('name', "plural_answers[right[#{right_count}[text]]]")
    input.setAttribute('id', "plural_answers[right[#{right_count}[text]]]")
    $('.answers-right')[0].appendChild(input)
    false

  $('.del-many-right').on 'click', ->
    if right_count > 1
      document.getElementById("plural_answers[right[#{right_count}[text]]]").remove()
      right_count--
    false
