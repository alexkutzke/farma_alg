class Carrie.Routers.Introductions extends Backbone.Marionette.AppRouter
  appRoutes:
    'los/:lo_id/introductions': 'index'
    'los/:lo_id/introductions/new': 'new'
    'los/:lo_id/introductions/edit/:id': 'edit'

class Carrie.Controllers.Introductions

  index: (lo_id) ->
    Carrie.Helpers.Session.Exists
      func: =>
        Carrie.Utils.Menu.highlight 'los-link'
        lo = @findLo(lo_id)

        Carrie.layouts.main.loadBreadcrumb
          1: name: 'Objetos de Aprendizagem', url: '/los'
          2: name: "Introduções do OA #{lo.get('name')}", url: ''

        lo.get('introductions').fetch
          wait: true
          success: (collection, response, options) =>
            index = new Carrie.CompositeViews.IntroductionIndex
              collection: lo.get('introductions')
              model: lo

            Carrie.layouts.main.content.show index
          error: (model, response, options) ->
            Carrie.Helpers.Notifications.Flash.error('Problema para carregar introduções')


  new: (lo_id) ->
    Carrie.Helpers.Session.Exists
      func: =>
        Carrie.Utils.Menu.highlight 'los-link'
        lo = @findLo(lo_id)

        Carrie.layouts.main.loadBreadcrumb
          1: name: 'Objetos de Aprendizagem', url: '/los'
          2: name: "Introduções do OA #{lo.get('name')}", url: "/los/#{lo.get('id')}/introductions"
          3: name: 'nova', url: ''

        Carrie.layouts.main.content.show new Carrie.Views.CreateOrSaveIntroduction(lo: lo)

  edit: (lo_id, id) ->
    Carrie.Helpers.Session.Exists
      func: =>
        Carrie.Utils.Menu.highlight 'los-link'
        lo = @findLo(lo_id)
        introduction = @findIntro(lo, id)

        introduction.fetch
          success: (model, response, options) =>
            Carrie.layouts.main.loadBreadcrumb
              1: name: 'Objetos de Aprendizagem', url: '/los'
              2: name: "Introduções do OA #{lo.get('name')}", url: "/los/#{lo.get('id')}/introductions"
              3: name: "Editar introdução #{model.get('title')}", url: ''

            Carrie.layouts.main.content.show new Carrie.Views.CreateOrSaveIntroduction(lo: lo, model: model)

          error: (model, response, options)->
            Carrie.Helpers.Notifications.Flash.error('Introdução não encontrada')

  findLo: (id) ->
    lo = Carrie.Models.Lo.findOrCreate(id)
    if not lo
      lo = new Carrie.Models.Lo({id: id})
      lo.fetch
        async: false
        error: (model, response, options) ->
          Carrie.Helpers.Notifications.Flash.error('Objeto de aprendizagem não encontrado')
    return lo

  findIntro: (lo, id) ->
    intro = Carrie.Models.Introduction.findOrCreate(id)
    intro = new Carrie.Models.Introduction({lo: lo, id: id}) if not intro
    return intro
