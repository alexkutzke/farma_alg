class Carrie.Routers.UserController
  index: ->
    if not Carrie.currentUser
      Backbone.history.navigate('/users/sign-in', true)
    else
      Carrie.layouts.main = new Carrie.Views.Layouts.Main()
      Carrie.main.show Carrie.layouts.main

  signIn: ->
    Carrie.Helpers.Session.notExists
      func: ->
        Carrie.layouts.unauthenticated.showView('login')

  signUp: ->
    Carrie.Helpers.Session.notExists
      func: ->
        Carrie.layouts.unauthenticated.showView('signup')

  passwords: ->
    Carrie.Helpers.Session.notExists
      func: ->
        Carrie.layouts.unauthenticated.showView('retrievePassword')

  editPassword: (token) ->
    Carrie.Helpers.Session.notExists
      func: =>
        Carrie.layouts.unauthenticated.resetPassword(token)

  perfil: ->
    Carrie.Helpers.Session.Exists
      func: =>
        Carrie.layouts.main.content.show new Carrie.Views.UserPerfil()



  #The `*options` catchall route is a well known value in Backbone's Routing
  #internals that represents any route that's not listed before it. It should to
  #be defined last if desired. We'll just have the presenter render a 404-style
  #error view.
  urlNotFound: ->
      $('#main').find('.alert-alert').remove()
      $('#main').prepend Carrie.Helpers.Notifications.error('Página não encontrada')
      Backbone.history.navigate('', true)
