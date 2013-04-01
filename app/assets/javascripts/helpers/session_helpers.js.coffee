Carrie.Helpers.Session = {}

Carrie.Helpers.Session.notExists = (data) ->
  data.message = 'Você já está logado' unless data.message
  if Carrie.currentUser
    Backbone.history.navigate('')
    Carrie.Utils.Alert.success(data.message, 3000)
  else
    data.func.call()

Carrie.Helpers.Session.Exists = (data) ->
  data.message = 'Você Precisa estar logado para acessar esta página' unless data.message
  unless Carrie.currentUser
    Backbone.history.navigate('/users/sign-in')
    Carrie.Utils.Alert.error(data.message, 5000)
  else
    data.func.call()
