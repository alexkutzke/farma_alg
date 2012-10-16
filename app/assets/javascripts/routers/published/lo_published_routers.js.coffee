class Carrie.Published.Routers.Lo extends Backbone.Marionette.AppRouter
  appRoutes:
    'published/los/:id': 'showPage'
    'published/los/:id/pages/:page': 'showPage'

    'published/teams/:team_id/los/:id': 'showPageWithTeam'
    'published/teams/:team_id/los/:id/pages/:page': 'showPageWithTeam'
