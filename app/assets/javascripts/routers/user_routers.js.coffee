class Carrie.Routers.UserRouters extends Backbone.Marionette.AppRouter
  appRoutes:
    '': 'index'
    'users/sign-in': 'signIn'
    'users/sign-up': 'signUp'
    'users/passwords': 'passwords'
    'users/password/edit/:token': 'editPassword'
    'users/perfil': 'perfil'
    '*options': 'urlNotFound'

