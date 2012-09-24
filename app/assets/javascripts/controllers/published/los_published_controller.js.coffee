class Carrie.Published.Routers.LoController

  showPage: (id, page) ->
    Carrie.Helpers.Session.Exists
      func: =>
        lo = Carrie.Published.Models.Lo.findOrCreate(id)
        lo = new Carrie.Published.Models.Lo(id: id) if not lo

        lo.fetch
          async: false
          success: (model) =>
            view = new Carrie.Published.Views.Lo(model: lo, page: page)
            Carrie.layouts.main.content.show view
          error: (response, status, error) ->
            Carrie.Utils.Alert.error('Objeto de aprendizagem não encontrado', 3000)
            Backbone.history.navigate('')
