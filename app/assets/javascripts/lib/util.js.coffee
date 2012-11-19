Carrie.Utils.Menu =
  show: (link) ->
    obj = $("\##{link}")

    $('ul#side-menu li').removeClass('active')
    $('ul#side-menu > li > ul.sub-menu').hide()

    if obj.length != 0
      obj.parent().addClass('active')

    $('ul#side-menu > li > ul.sub-menu:has(li.active)').show()


Carrie.Utils.Alert =
  success: (msg, time) ->
    msg_el = Carrie.Helpers.Notifications.success(msg)
    if time
      $('#alert-fixed').append(msg_el)
      $('#alert-fixed .alert').hide 'blind', { percent: 0 }, time,  ->
        $(this).remove()
    else
      $('#alert-msg').append(msg_el)

  error: (msg, time) ->
    msg_el = Carrie.Helpers.Notifications.error(msg)
    if time
      $('#alert-fixed').append(msg_el)
      $('#alert-fixed .alert').hide 'blind', { percent: 0 }, time,  ->
        $(this).remove()
    else
      $('#alert-msg').append(msg_el)

  clear: (el) ->
    el = 'form' unless el
    $('.alert').remove()
    $(el).find('input.btn-primary').button('loading')
    $(el).find('.alert-error').remove()
    $(el).find('.help-block').remove()
    $(el).find('.control-group.error').removeClass('error')

  showFormErrors: (form_errors, el) ->
    _(form_errors).each (errors, field) ->
      $(".#{field}_group").addClass 'error'
      _(errors).each (error, i) ->
        $(el).find(".#{field}_group .controls").append(Carrie.Helpers.FormHelpers.fieldHelp(error))

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

Carrie.Utils.Pluralize = (amount, word_s, word_p) ->
  s = amount
  if amount == 1
    s = "#{s} #{word_s}"
  else
    s = "#{s} #{word_p}"
  s
