$ ->
  tag_colors = ['primary', 'danger', 'success', 'warning']
  for key, value of JSON.parse($('.tag-container input')[0].value)
    tag = document.createElement('span')
    tag.className = 'tag label label-'+tag_colors[parseInt(key)%%4]
    tag.textContent = value.name+' '
    tag_close = document.createElement('i')
    tag_close.className = 'fa fa-times close-tag'
    tag_close.setAttribute('data-deny_group', value.id)
    tag.appendChild(tag_close)
    $('.tag-container')[0].appendChild(tag)
    false

  $('.close-tag').on 'click', ->
    if (confirm($('#del_attention')[0].value))
      $.post("/toasts/"+$('#toast_id')[0].value+"/deny_group", {group: $(this).data('deny_group')})
