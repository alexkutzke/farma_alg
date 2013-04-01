class Carrie.Routers.Fractais extends Backbone.Marionette.AppRouter
  appRoutes:
    'fractais': 'index'

class Carrie.Controllers.Fractais

  index: ->
    Carrie.Helpers.Session.Exists
      func: =>
        Carrie.Utils.Menu.highlight 'fractais-link'
        Carrie.layouts.main.loadBreadcrumb
          1: name: 'Fractais', url: '/fractais'

        Carrie.layouts.main.content.show new Carrie.Views.FractalIndex()
