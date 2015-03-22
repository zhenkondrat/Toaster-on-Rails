CKEDITOR.on 'dialogDefinition', (ev) ->
  if ev.data.name == 'image'
    definition = ev.data.definition
    definition.removeContents 'Link'
    definition.removeContents 'advanced'
    definition.minHeight = 150
    definition.minWidth = 400
    infoTab = definition.getContents('info')
    infoTab.remove 'txtAlt'
    infoTab.remove 'txtBorder'
    infoTab.remove 'txtHSpace'
    infoTab.remove 'txtVSpace'
    infoTab.remove 'cmbAlign'
    infoTab.get('htmlPreview').hidden = true
  return
