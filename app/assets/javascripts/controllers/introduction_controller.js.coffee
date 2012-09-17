class Carrie.Routers.IntroductionController

  index: (lo_id) ->
    Carrie.Helpers.Session.Exists
      func: =>
        lo = @find_model(lo_id)

        @setBreadcrumb(lo)
        Carrie.layouts.main.addBreadcrumb('Introduções do OA ' + lo.get('name'), '', true)

        lo.get('introductions').fetch
          wait: true
          success: (collection, response) =>
            index = new Carrie.CompositeViews.IntroductionIndex
              collection: lo.get('introductions')
              model: lo
            Carrie.layouts.main.content.show index

          error: (model, response)->
            console.log(response)
            Carrie.Utils.Alert.error('Problema para carregar introduções')


  new: (lo_id) ->
    Carrie.Helpers.Session.Exists
      func: =>
        lo = @find_model(lo_id)

        @setBreadcrumb(lo)
        Carrie.layouts.main.addBreadcrumb('Introduções do OA ' + lo.get('name'), '/los/' + lo.get('id') + '/introductions')
        Carrie.layouts.main.addBreadcrumb('nova', '', true)

        Carrie.layouts.main.content.show new Carrie.Views.CreateOrSaveIntroduction(lo: lo)

  edit: (lo_id, id) ->
    Carrie.Helpers.Session.Exists
      func: =>
        lo = @find_model(lo_id)

        introduction = new @find_intro(lo, id)

        introduction.fetch
          success: (model, response) =>
            console.log(model)
            @setBreadcrumb(lo)
            bread = 'Introduções do OA ' + lo.get('name')
            Carrie.layouts.main.addBreadcrumb(bread, '/los/' + lo.get('id') + '/introductions')
            Carrie.layouts.main.addBreadcrumb('Editar introducão ' + model.get('title') , '', true)

            Carrie.layouts.main.content.show new Carrie.Views.CreateOrSaveIntroduction(lo: lo, model: model)
          error: (model, response)->
            Carrie.Utils.Alert.error('Introdução não encontroda')

  find_model: (id) ->
    lo = Carrie.Models.Lo.findOrCreate(id)

    if not lo
      lo = new Carrie.Models.Lo({id: id})
      lo.fetch
        async: false
        error: (model, response)->
          Carrie.Utils.Alert.error('Objeto de aprendizagem não encontrado')

    return lo

  find_intro: (lo, id) ->
    intro = Carrie.Models.Introduction.findOrCreate(id)

    if not intro
      intro = new Carrie.Models.Introduction({lo: lo, id: id})
      intro.fetch
        async: false
        error: (model, response)->
          Carrie.Utils.Alert.error('Introdução não encontrada')

    return intro

  setBreadcrumb: (model) ->
    $('#los-link').parent().siblings().removeClass('active')
    $('#los-link').parent().addClass('active')

    Carrie.layouts.main.reloadBreadcrumb()
    Carrie.layouts.main.addBreadcrumb('Objetos de Aprendizagem', '/los')
