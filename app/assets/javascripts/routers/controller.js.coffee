class Carrie.Routers.Controller
  index: ->
    if not Carrie.currentUser
      Backbone.history.navigate('/users/sign-in', true)

  sign_in: ->
    Carrie.Helpers.Session.notExists
      func: ->
        Carrie.layouts.unauthenticated.showView('login')

  sign_up: ->
    Carrie.Helpers.Session.notExists
      func: ->
        Carrie.layouts.unauthenticated.showView('signup')

  passwords: ->
    Carrie.Helpers.Session.notExists
      func: ->
        Carrie.layouts.unauthenticated.showView('retrievePassword')
