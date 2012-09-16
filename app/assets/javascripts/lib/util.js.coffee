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

  clear: ->
    $('.alert').remove()
    $('form').find('input.btn-primary').button('loading')
    $('form').find('.alert-error').remove()
    $('form').find('.help-block').remove()
    $('form').find('.control-group.error').removeClass('error')

  showFormErrors: (form_errors) ->
    _(form_errors).each (errors, field) ->
      $("\##{field}_group").addClass 'error'
      _(errors).each (error, i) ->
        $("\##{field}_group .controls").append(Carrie.Helpers.FormHelpers.fieldHelp(error))
