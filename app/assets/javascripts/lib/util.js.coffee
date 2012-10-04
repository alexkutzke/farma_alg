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
        console.log error

  clearWhoHas: (key) ->
    $.each CKEDITOR.instances, (i, editor) ->
      try
        if editor.name.search(key) != -1
          editor.destroy()
      catch error
        console.log error

Carrie.Bootstrap =
  popoverPlacement: ->
    width = $(window).width()
    if width >= 500
      return 'right'
    else
      return 'bottom'
