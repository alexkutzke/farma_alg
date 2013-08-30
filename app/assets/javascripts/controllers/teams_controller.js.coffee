class Carrie.Routers.Teams extends Backbone.Marionette.AppRouter
  appRoutes:
    'teams/enrolled': 'enrolled'
    'teams/created': 'created'
    'teams/edit/:id': 'edit'
    'teams/new': 'new'
    'teams': 'index'

class Carrie.Controllers.Teams

  index: ->
    Carrie.Helpers.Session.Exists
      func: ->
        Carrie.Utils.Menu.highlight 'teams-link'
        Carrie.layouts.main.loadBreadcrumb
          1: name: 'Turmas que estou matriculado', url: '/teams/enrolled'
          2: name: 'Todas turmas', url: ''

        Carrie.layouts.main.content.show new Carrie.CompositeViews.Teams

  enrolled: ->
    Carrie.Helpers.Session.Exists
      func: ->
        Carrie.Utils.Menu.highlight 'enrolled-link'
        Carrie.layouts.main.loadBreadcrumb
          1: name: 'Turmas que estou matriculado', url: ''

        view = new Carrie.CompositeViews.Enrolled
          collection: new Carrie.Collections.TeamsEnrolled()

        Carrie.layouts.main.content.show view

  created: ->
    Carrie.Helpers.Session.Exists
      func: ->
        Carrie.Utils.Menu.highlight 'created-link'
        Carrie.layouts.main.loadBreadcrumb
          1: name: 'Turmas que criei', url: ''

        created = new Carrie.Collections.TeamsCreated()
        view = new Carrie.CompositeViews.TeamsCreated collection: created
        Carrie.layouts.main.content.show view

  new: ->
    Carrie.Helpers.Session.Exists
      func: =>
        Carrie.Utils.Menu.highlight 'created-link'
        Carrie.layouts.main.loadBreadcrumb
          1: name: 'Minhas turmas', url: '/teams/created'
          2: name: 'nova',''

        Carrie.layouts.main.content.show new Carrie.Views.CreateOrSaveTeam()

  edit: (id) ->
    Carrie.Helpers.Session.Exists
      func: =>
        Carrie.Utils.Menu.highlight 'created-link'

        team = Carrie.Models.Team.findOrCreate(id)
        team = new Carrie.Models.Team({id: id}) if not team

        team.fetch
          success: (model, response, options) =>
            Carrie.layouts.main.loadBreadcrumb
              1: name: 'Minhas turmas', url: '/teams/created'
              2: name: "Editar turma #{model.get('name')}", url: ''

            Carrie.layouts.main.content.show new Carrie.Views.CreateOrSaveTeam(model: model)

          error: (model, response, options) ->
            Carrie.Helpers.Notifications.Flash.error 'Turma não encontrada'
