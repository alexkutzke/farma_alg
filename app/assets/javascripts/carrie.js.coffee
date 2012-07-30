window.Carrie = new Backbone.Marionette.Application()

Carrie.Views = {}
Carrie.Views.Layouts = {}
Carrie.Models = {}
Carrie.Collections = {}
Carrie.Routers = {}
Carrie.Helpers = {}

Carrie.layouts = {}

Carrie.addRegions
  main: '#main'
  top_menu: '#top_menu'
  welcome: '#welcome'

Carrie.bind 'initialize:after', ->
  user = $('body').data('logged')
  if user
    Carrie.currentUser = new Carrie.Models.User(user)
    Carrie.vent.trigger 'authentication:logged_in'
  else
    Carrie.vent.trigger 'authentication:logged_out'

  new Carrie.Routers.App controller: new Carrie.Routers.Controller()
  Backbone.history.start pushState: true


Carrie.vent.on 'authentication:logged_out', ->
  Carrie.main.show Carrie.layouts.unauthenticated

Carrie.vent.on 'authentication:logged_in', ->
  Carrie.main.show Carrie.layouts.main
  Carrie.welcome.show new Carrie.Views.Welcome model: Carrie.currentUser

$ ->
  Carrie.start()
  # BootStrap Tooltip
