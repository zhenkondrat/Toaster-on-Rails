next_question = () ->
  $('.next_question').click()
  false
if $('.timer').length != 0
  setTimeout next_question, $('.timer').data('time')*1000
