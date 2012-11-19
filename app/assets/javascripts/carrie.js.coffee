window.Carrie = new Backbone.Marionette.Application()

Carrie.Views = {}
Carrie.Models = {}
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
Carrie.Published.Views = {}

Carrie.Models.Retroaction = {}
Carrie.Views.Retroaction = {}
Carrie.CompositeViews.Retroaction = {}
Carrie.Collections.Retroaction = {}

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

  new Carrie.Routers.UserRouters controller: new Carrie.Routers.UserController()
  new Carrie.Routers.LoRouters controller: new Carrie.Routers.LoController()
  new Carrie.Routers.IntroductionRouters controller: new Carrie.Routers.IntroductionController()
  new Carrie.Routers.ExerciseRouters controller: new Carrie.Routers.ExerciseController()
  new Carrie.Routers.AnswerRouters controller: new Carrie.Routers.AnswersController()
  new Carrie.Routers.FractalRouters controller: new Carrie.Routers.FractalController()

  new Carrie.Published.Routers.Lo controller: new Carrie.Published.Routers.LoController()

  new Carrie.Routers.Team controller: new Carrie.Routers.TeamController()

  Backbone.history.start pushState: true


Carrie.vent.on 'authentication:logged_out', ->
  Carrie.main.show Carrie.layouts.unauthenticated

Carrie.vent.on 'authentication:logged_in', ->
  Carrie.main.show Carrie.layouts.main
  Carrie.welcome.show new Carrie.Views.Welcome model: Carrie.currentUser

$ ->
  Carrie.start()
  # BootStrap Tooltip
