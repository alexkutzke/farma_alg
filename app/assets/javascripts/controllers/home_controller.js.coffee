class Carrie.Routers.Home extends Backbone.Marionette.AppRouter
  appRoutes:
    '': 'welcome'
    'welcome': 'welcome'
    'lo_example': 'lo_example'
    'lo_example/pages/:page': 'lo_example'
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

  lo_example: (page) ->
    lo = Carrie.Published.Models.Lo.findOrCreate()
    lo = new Carrie.Published.Models.Lo() if not lo

    lo.fetch
      url: '/api/home/lo_example'
      async: false
      success: (model, response, options) =>
        lo.set('url_page', "/lo_example")

        # Prepare layout
        Carrie.layouts.main = new Carrie.Views.Layouts.Main()
        Carrie.main.show Carrie.layouts.main
        $('#main-menu').remove()
        $('.toggle-menu').remove()
        $('#main-container').addClass('span12')

        Carrie.layouts.main.content.show new Carrie.Published.Views.Lo(model: lo, page: page)
      error: (model, response, options) =>
        Carrie.Helpers.Notifications.Flash.error('Objeto de aprendizagem não encontrado')
        Backbone.history.navigate('')

  #The `*options` catchall route is a well known value in Backbone's Routing
  #internals that represents any route that's not listed before it. It should to
  #be defined last if desired. We'll just have the presenter render a 404-style
  #error view.
  urlNotFound: ->
    $('#main').find('.alert-alert').remove()
    $('#main').prepend Carrie.Helpers.Notifications.error('Página não encontrada')
    Backbone.history.navigate('', true)
