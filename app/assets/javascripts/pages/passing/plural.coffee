$ ->
  $('.learning-next').on 'click', ->
    $('.right-answer').attr('style', 'background-color: #a4d11b;')
    next = ->
      $('#passing-form').submit()
    setTimeout(next, 1000)
    false
