next_question = ->
  clearInterval(intervalID)
  $('.next_question').click()
  false
timer_tick = ->
  time -= 1
  $('.timer-ticker').html(time.toString())
if $('.timer').length != 0
  time = parseInt($('.timer').data('time'))
  $('.timer-ticker').html(time.toString())
  setTimeout next_question, $('.timer').data('time')*1000
  intervalID = window.setInterval timer_tick, 1000
