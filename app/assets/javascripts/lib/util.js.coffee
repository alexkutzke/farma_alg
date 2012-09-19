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
