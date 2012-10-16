class Carrie.Published.Routers.LoController

  showPage: (id, page) ->
    Carrie.Helpers.Session.Exists
      func: =>
        Carrie.Utils.Menu.show ''
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

  showPageWithTeam: (team_id, id, page) ->
    Carrie.Helpers.Session.Exists
      func: =>
        Carrie.Utils.Menu.show ''
        lo = Carrie.Published.Models.Lo.findOrCreate(id)
        lo = new Carrie.Published.Models.Lo(id: id) if not lo

        lo.set('team_id', team_id)
        lo.fetch
          async: false
          success: (model) =>
            view = new Carrie.Published.Views.Lo(model: lo, page: page, team_id: team_id)
            Carrie.layouts.main.content.show view
          error: (response, status, error) ->
            Carrie.Utils.Alert.error('Objeto de aprendizagem não encontrado', 3000)
            Backbone.history.navigate('')
