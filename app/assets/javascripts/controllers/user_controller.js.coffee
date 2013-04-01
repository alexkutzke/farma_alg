class Carrie.Routers.User extends Backbone.Marionette.AppRouter
  appRoutes:
    'users/sign-in': 'signIn'
    'users/sign-up': 'signUp'
    'users/passwords': 'passwords'
    'users/password/edit/:token': 'editPassword'
    'users/perfil': 'perfil'

class Carrie.Controllers.User
  signIn: ->
    Carrie.Helpers.Session.notExists
      func: ->
        Carrie.main.show Carrie.layouts.unauthenticated
        Carrie.layouts.unauthenticated.showView('login')

  signUp: ->
    Carrie.Helpers.Session.notExists
      func: ->
        Carrie.main.show Carrie.layouts.unauthenticated
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
