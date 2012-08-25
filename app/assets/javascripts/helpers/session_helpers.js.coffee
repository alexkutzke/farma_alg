Carrie.Helpers.Session = {}

Carrie.Helpers.Session.notExists = (data) ->
  data.message = 'Você já está logado' unless data.message
  if Carrie.currentUser
    $('#main').find('.alert-alert').remove()
    $('#main').prepend Carrie.Helpers.Notifications.alert('alert', data.message)
    Backbone.history.navigate('')
  else
    data.func.call()

Carrie.Helpers.Session.Exists = (data) ->
  data.message = 'Você Precisa estar logado' unless data.message
  unless Carrie.currentUser
    $('#main').find('.alert-alert').remove()
    $('#main').prepend Carrie.Helpers.Notifications.alert('alert', data.message)
    Backbone.history.navigate('/users/sign-in')
  else
    data.func.call()
