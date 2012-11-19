class Carrie.Routers.FractalController

  index: ->
    Carrie.Helpers.Session.Exists
      func: =>
        Carrie.Utils.Menu.show 'fractais-link'
        Carrie.layouts.main.reloadBreadcrumb()
        Carrie.layouts.main.addBreadcrumb('Fractais', '/fractais', true)

        Carrie.layouts.main.content.show new Carrie.Views.FractalIndex()
