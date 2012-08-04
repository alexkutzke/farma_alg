class Carrie.Routers.App extends Backbone.Marionette.AppRouter
  appRoutes:
    '': 'index'
    'users/sign-in': 'sign_in'
    'users/sign-up': 'sign_up'
    'users/passwords': 'passwords'
    '*options': 'urlNotFound'

