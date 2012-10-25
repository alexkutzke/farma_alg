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
            Carrie.layouts.main.hideMenu()
          error: (response, status, error) ->
            Carrie.Utils.Alert.error('Objeto de aprendizagem não encontrado', 3000)
            Backbone.history.navigate('')

  showPageWithTeam: (team_id, id, page) ->
    Carrie.Helpers.Session.Exists
      func: =>
        Carrie.Utils.Menu.show ''
        team = Carrie.Models.Team.findOrCreate(team_id)
        team = new Carrie.Models.Team(id: team_id) if not team

        lo = Carrie.Published.Models.Lo.findOrCreate(id)
        lo = new Carrie.Published.Models.Lo(id: id, team_id: team_id) if not lo

        team.fetch
          async: false
          success: (model) =>
            lo.set('team', team)
            lo.fetch
              async: false
              success: (model) =>
                view = new Carrie.Published.Views.Lo(model: lo, page: page, team_id: team_id)
                Carrie.layouts.main.content.show view
                Carrie.layouts.main.hideMenu()
              error: (response, status, error) ->
                Carrie.Utils.Alert.error('Objeto de aprendizagem não encontrado', 3000)
                Backbone.history.navigate('')
          error: (response, status, error) ->
            Carrie.Utils.Alert.error('Turma não encontrada', 3000)
            Backbone.history.navigate('')
