window.Carrie = new Backbone.Marionette.Application()

Carrie.Views = {}
Carrie.Models = {}
Carrie.Controllers = {}
Carrie.Published = {}
Carrie.Collections = {}
Carrie.CompositeViews = {}
Carrie.Routers = {}
Carrie.Helpers = {}
Carrie.Utils = {}

Carrie.Views.Layouts = {}
Carrie.Published.Models = {}
Carrie.Published.Collections = {}
Carrie.Published.Routers = {}
Carrie.Published.Controllers = {}
Carrie.Published.Views = {}

Carrie.Models.Retroaction = {}
Carrie.Views.Retroaction = {}
Carrie.CompositeViews.Retroaction = {}
Carrie.Collections.Retroaction = {}

Carrie.layouts = {}

Carrie.addRegions
  main: '#main'
  header_left_menu: '#header_left_menu'
  header_right_menu: '#header_right_menu'

Carrie.Routers.load = ->
  # Define Routers
  new Carrie.Routers.Home          controller: new Carrie.Controllers.Home()
  new Carrie.Routers.User          controller: new Carrie.Controllers.User()
  new Carrie.Routers.Los           controller: new Carrie.Controllers.Los()
  new Carrie.Routers.Introductions controller: new Carrie.Controllers.Introductions()
  new Carrie.Routers.Exercises     controller: new Carrie.Controllers.Exercises()
  new Carrie.Routers.Answers       controller: new Carrie.Controllers.Answers()
  new Carrie.Routers.Fractais      controller: new Carrie.Controllers.Fractais()
  new Carrie.Routers.Teams         controller: new Carrie.Controllers.Teams()
  new Carrie.Published.Routers.Los controller: new Carrie.Published.Controllers.Los()

Carrie.bind 'initialize:after', ->
  Carrie.layouts.main = new Carrie.Views.Layouts.Main()
  user = $('body').data('logged')
  if user
    Carrie.currentUser = new Carrie.Models.User(user)
    Carrie.vent.trigger 'authentication:logged_in'
  else
    Carrie.vent.trigger 'authentication:logged_out'

  Carrie.Routers.load()
  Backbone.history.start pushState: true


#Configure Layout and header for non authenticate user
Carrie.vent.on 'authentication:logged_out', ->
  Carrie.header_left_menu.show new Carrie.Views.UnAuthenticateHLM
  Carrie.header_right_menu.show new Carrie.Views.UnAuthenticateHRM

#Configure Layout and header for non authenticate user
Carrie.vent.on 'authentication:logged_in', ->
  Carrie.header_left_menu.show new Carrie.Views.AuthenticateHLM
  Carrie.header_right_menu.show new Carrie.Views.AuthenticateHRM model: Carrie.currentUser
  Carrie.main.show Carrie.layouts.main

$ ->
  Carrie.start()
