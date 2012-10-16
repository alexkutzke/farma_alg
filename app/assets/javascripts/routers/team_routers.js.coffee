class Carrie.Routers.Team extends Backbone.Marionette.AppRouter
  appRoutes:
    'teams/enrolled': 'enrolled'
    'teams/created': 'created'
    'teams/edit/:id': 'edit'
    'teams/new': 'new'
    'teams': 'index'
