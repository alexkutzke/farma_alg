class Carrie.Routers.LoController
  list: ->
    Carrie.Helpers.Session.Exists
      func: ->
        los = new Carrie.Collections.Lo
        losView = new Carrie.CompositeViews.Los
          collection: los

        Carrie.Utils.Menu.show 'los-link'

        obj = $('#los-link')

        Carrie.layouts.main.reloadBreadcrumb()
        Carrie.layouts.main.addBreadcrumb(obj.text(), obj.data('url'), true)

        Carrie.layouts.main.content.show losView

        los.fetch()

  new: ->
    Carrie.Helpers.Session.Exists
      func: ->
        Carrie.layouts.main.reloadBreadcrumb()
        Carrie.layouts.main.addBreadcrumb('Objetos de Aprendizagem', '/los')
        Carrie.layouts.main.addBreadcrumb('novo', '/los/new', true)

        Carrie.layouts.main.content.show new Carrie.Views.CreateOrSaveLo()

  edit: (id) ->
     Carrie.Helpers.Session.Exists
      func: =>
        lo = @find_model(id)

        lo.fetch
          success: (model, response) ->
            console.log(model)
            Carrie.layouts.main.reloadBreadcrumb()
            Carrie.layouts.main.addBreadcrumb('Objetos de Aprendizagem', '/los')
            Carrie.layouts.main.addBreadcrumb('Editar OA '+ model.get('name'), '/los/edit', true)
            Carrie.layouts.main.content.close()
            Carrie.layouts.main.content.show new Carrie.Views.CreateOrSaveLo(model: lo)
          error: ->
            $('#content').find('.alert-alert').remove()
            $('#content').prepend Carrie.Helpers.Notifications.error('OA não encontrada')


  showHelp: ->
     Carrie.Helpers.Session.Exists
      func: =>
        Carrie.layouts.main.reloadBreadcrumb()
        Carrie.layouts.main.addBreadcrumb('Ajuda com a FARMA', '', true)
        Carrie.layouts.main.content.show new Carrie.Views.Help()

        Carrie.Utils.Menu.show 'help-link'


  find_model: (id) ->
    lo = Carrie.Models.Lo.findOrCreate(id)

    if not lo
      lo = new Carrie.Models.Lo({id: id})
      lo.fetch
        async: false
        error: (model, response)->
          Carrie.Utils.Alert.error('Objeto de aprendizagem não encontrado')

    return lo
