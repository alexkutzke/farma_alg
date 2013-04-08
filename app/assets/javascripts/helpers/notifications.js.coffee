Carrie.Helpers.Notifications = {}

Carrie.Helpers.Notifications.alert = (alertType, message) ->
  HandlebarsTemplates['shared/notifications']
    'alertType': alertType
    'message': message

Carrie.Helpers.Notifications.error = (message)  ->
  this.alert('error', message)

Carrie.Helpers.Notifications.success = (message) ->
  this.alert('success', message)

Handlebars.registerHelper 'notify_error', (msg) ->
  msg = Handlebars.Utils.escapeExpression(msg)
  new Handlebars.SafeString(Carrie.Helpers.Notifications.error(msg))

Handlebars.registerHelper 'notify_success', (msg) ->
  msg = Handlebars.Utils.escapeExpression(msg)
  new Handlebars.SafeString(Carrie.Helpers.Notifications.success(msg))

Carrie.Helpers.Notifications.Flash =
  error: (msg) ->
    $('#content').find('.alert-alert').remove()
    $('#content').prepend Carrie.Helpers.Notifications.error(msg)

Carrie.Helpers.Notifications.Flash =
  success: (msg) ->
    $('#content').find('.alert-alert').remove()
    $('#content').prepend Carrie.Helpers.Notifications.success(msg)

  error: (msg) ->
    $('#content').find('.alert-alert').remove()
    $('#content').prepend Carrie.Helpers.Notifications.error(msg)

Carrie.Helpers.Notifications.Top =
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

Carrie.Helpers.Notifications.Form =
  clear: (el) ->
    el = 'form' unless el
    $('.alert').remove()
    $(el).find('.alert-error').remove()
    $(el).find('.help-block').remove()
    $(el).find('.control-group.error').removeClass('error')

  showErrors: (form_errors, el) ->
    _(form_errors).each (errors, field) ->
      $(".#{field}_group").addClass 'error'
      _(errors).each (error, i) ->
        $(el).find(".#{field}_group .controls").append(Carrie.Helpers.FormHelpers.fieldHelp(error))

  before: (txtMsg, el) ->
    el = 'form' unless el
    msg = Carrie.Helpers.Notifications.error txtMsg
    $(el).before(msg)

  loadSubmit: (el) ->
    el = 'form' unless el
    $(el).find("input[type='submit']").button('loading')

  resetSubmit: (el) ->
    el = 'form' unless el
    $(el).find("input[type='submit']").button('reset')
