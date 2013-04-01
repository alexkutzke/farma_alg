class Carrie.Routers.Home extends Backbone.Marionette.AppRouter
  appRoutes:
    '': 'index'
    'welcome': 'welcome'
    '*options': 'urlNotFound'

class Carrie.Controllers.Home
  index: ->
    Carrie.main.show new Carrie.Views.HomeIndex
    $('.carousel').carousel
      interval: 7000

  welcome: ->
    Carrie.Helpers.Session.Exists
      func: ->
        Carrie.layouts.main = new Carrie.Views.Layouts.Main()
        Carrie.main.show Carrie.layouts.main


  #The `*options` catchall route is a well known value in Backbone's Routing
  #internals that represents any route that's not listed before it. It should to
  #be defined last if desired. We'll just have the presenter render a 404-style
  #error view.
  urlNotFound: ->
      $('#main').find('.alert-alert').remove()
      $('#main').prepend Carrie.Helpers.Notifications.error('Página não encontrada')
      Backbone.history.navigate('', true)
