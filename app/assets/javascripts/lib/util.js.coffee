Carrie.Utils.Menu =
  highlight: (link) ->
    obj = $("\##{link}")

    $('ul#side-menu li').removeClass('active')
    $('ul#side-menu > li > ul.sub-menu').hide()

    if obj.length != 0
      obj.parent().addClass('active')

    $('ul#side-menu > li > ul.sub-menu:has(li.active)').show()
    return obj


Carrie.CKEDITOR =
  clear: ->
    $.each CKEDITOR.instances, (i, editor) ->
      try
        editor.destroy()
      catch error
        #console.log error

  clearWhoHas: (key) ->
    $.each CKEDITOR.instances, (i, editor) ->
      try
        if editor.name.search(key) != -1
          editor.destroy()
      catch error
        #console.log error

  show: (el) ->
    el = '#ckeditor' unless el
    setTimeout ( ->
      $(el).ckeditor({language: 'pt-br'})
    ), 100


Carrie.Bootstrap =
  popoverPlacement: ->
    width = $(window).width()
    if width >= 500
      return 'right'
    else
      return 'bottom'

Carrie.Utils.Loading = (obj) ->
  obj.on 'fetch', ->
    $('.loading').show()
  , obj
  obj.on 'reset', ->
    $('.loading').hide()
  , obj
  obj.on 'change', ->
    $('.loading').hide()
  , obj
  obj.on 'sync', ->
    $('.loading').hide()
  , obj

Carrie.Utils.Pluralize = (amount, word_s, word_p) ->
  s = amount
  if amount == 1
    s = "#{s} #{word_s}"
  else
    s = "#{s} #{word_p}"
  s
