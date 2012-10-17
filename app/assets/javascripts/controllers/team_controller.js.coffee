class Carrie.Routers.TeamController

  index: ->
    Carrie.Helpers.Session.Exists
      func: ->
        Carrie.layouts.main.reloadBreadcrumb()
        Carrie.layouts.main.addBreadcrumb('Turmas que estou matriculado', '/teams/enrolled')
        Carrie.layouts.main.addBreadcrumb('Todas turmas', '', true)
        Carrie.Utils.Menu.show 'enrolled-link'

        Carrie.layouts.main.content.show new Carrie.CompositeViews.Teams

  enrolled: ->
    Carrie.Helpers.Session.Exists
      func: ->
        Carrie.layouts.main.reloadBreadcrumb()
        Carrie.layouts.main.addBreadcrumb('Turmas que estou matriculado', '', true)

        Carrie.Utils.Menu.show 'enrolled-link'

        enrolled = new Carrie.Collections.TeamsEnrolled()
        view = new Carrie.CompositeViews.Enrolled
          collection: enrolled

        Carrie.layouts.main.content.show view

  created: ->
    Carrie.Helpers.Session.Exists
      func: ->
        Carrie.layouts.main.reloadBreadcrumb()
        Carrie.layouts.main.addBreadcrumb('Turmas que criei', '', true)

        Carrie.Utils.Menu.show 'created-link'

        created = new Carrie.Collections.TeamsCreated()
        view = new Carrie.CompositeViews.TeamsCreated
          collection: created

        Carrie.layouts.main.content.show view

  edit: (id) ->
    Carrie.Helpers.Session.Exists
      func: =>
        team = @find_model(id)

        team.fetch
          success: (model, response) =>
            Carrie.layouts.main.reloadBreadcrumb()
            Carrie.layouts.main.addBreadcrumb('Minhas turmas', '/teams/created')
            Carrie.layouts.main.addBreadcrumb('Editar turma ' + model.get('name') , '', true)

            Carrie.layouts.main.content.show new Carrie.Views.CreateOrSaveTeam(model: model)
            Carrie.Utils.Menu.show 'created-link'

          error: (model, response)->
            Carrie.Utils.Alert.error('Team não encontroda')

  new: ->
    Carrie.Helpers.Session.Exists
      func: =>
        Carrie.layouts.main.reloadBreadcrumb()
        Carrie.layouts.main.addBreadcrumb('Minhas turmas', '/teams/created')
        Carrie.layouts.main.addBreadcrumb('nova', '', true)
        Carrie.layouts.main.content.show new Carrie.Views.CreateOrSaveTeam()

  find_model: (id) ->
    team = Carrie.Models.Team.findOrCreate(id)

    if not team
      team = new Carrie.Models.Team({id: id})
      team.fetch
        async: false
        error: (model, response)->
          Carrie.Utils.Alert.error('Turma não encontrada')
    return team
