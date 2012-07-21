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
