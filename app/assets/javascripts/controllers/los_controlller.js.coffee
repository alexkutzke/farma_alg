class Carrie.Routers.Los extends Backbone.Marionette.AppRouter
  appRoutes:
    'los': 'list'
    'los/new': 'new'
    'los/edit/:id': 'edit'
    'help' : 'showHelp'

class Carrie.Controllers.Los
  list: ->
    Carrie.Helpers.Session.Exists
      func: ->
        los = new Carrie.Collections.Los
        losView = new Carrie.CompositeViews.Los collection: los

        obj = Carrie.Utils.Menu.highlight 'los-link'

        Carrie.layouts.main.loadBreadcrumb
          1: name: obj.text(), url: obj.data('url')

        Carrie.layouts.main.content.show losView
        los.fetch()

  new: ->
    Carrie.Helpers.Session.Exists
      func: ->
        Carrie.Utils.Menu.highlight 'los-link'
        Carrie.layouts.main.loadBreadcrumb
          1: name: 'Objetos de Aprendizagem', url: '/los'
          2: name: 'novo', url: '/los/new'

        Carrie.layouts.main.content.show new Carrie.Views.CreateOrSaveLo()

  edit: (id) ->
     Carrie.Helpers.Session.Exists
      func: =>
        Carrie.Utils.Menu.highlight 'los-link'

        lo = Carrie.Models.Lo.findOrCreate(id)
        lo = new Carrie.Models.Lo({id: id}) if not lo

        lo.fetch
          success: (model, response, options) ->
            Carrie.layouts.main.loadBreadcrumb
              1: name: 'Objetos de Aprendizagem', url: '/los'
              2: name: "Editar OA #{model.get('name')}", url: '/los/edit'

            Carrie.layouts.main.content.close()
            Carrie.layouts.main.content.show new Carrie.Views.CreateOrSaveLo(model: lo)
          error: ->
            Carrie.Helpers.Notifications.Flash.error('Objeto de aprendizagem não encontrado')


  showHelp: ->
     Carrie.Helpers.Session.Exists
      func: =>
        Carrie.Utils.Menu.highlight 'help-link'
        Carrie.layouts.main.loadBreadcrumb
          1: name: 'Ajuda com a FARMA', url: ''

        Carrie.layouts.main.content.show new Carrie.Views.Help()
