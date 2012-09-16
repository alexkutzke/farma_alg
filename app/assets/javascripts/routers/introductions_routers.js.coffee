class Carrie.Routers.IntroductionRouters extends Backbone.Marionette.AppRouter
  appRoutes:
    'los/:lo_id/introductions': 'index'
    'los/:lo_id/introductions/new': 'new'
    'los/:lo_id/introductions/edit/:id': 'edit'

