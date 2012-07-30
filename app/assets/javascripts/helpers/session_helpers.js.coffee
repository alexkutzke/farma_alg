Carrie.Helpers.Session = {}

Carrie.Helpers.Session.notExists = (data) ->
  data.message = 'Você já está logado' unless data.message
  if Carrie.currentUser
    $('#main').find('.alert-alert').remove()
    $('#main').prepend Carrie.Helpers.Notifications.alert('alert', data.message)
    Backbone.history.navigate('')
  else
    data.func.call()

