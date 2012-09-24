class Carrie.Published.Routers.Lo extends Backbone.Marionette.AppRouter
  appRoutes:
    'published/los/:id': 'showPage'
    'published/los/:id/pages/:page': 'showPage'
