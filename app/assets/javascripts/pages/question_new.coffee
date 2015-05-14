$ ->
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
