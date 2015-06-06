$ ->
  $( '.sortable' ).sortable(
    stop: (event, ui) ->
      if $(ui.item).parents('.associations_left')
        $('#associations_left').val("#{$(item).data('id') for item in $('.associations_left .association-item')}")
      else
        $('#associations_right').val("#{$(item).data('id') for item in $('.associations_right .association-item')}")
  )
  $( '.sortable' ).disableSelection()
