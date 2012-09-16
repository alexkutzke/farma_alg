class Carrie.Routers.ExerciseRouters extends Backbone.Marionette.AppRouter
  appRoutes:
    'los/:lo_id/exercises': 'index'
    'los/:lo_id/exercises/new': 'new'
    'los/:lo_id/exercises/edit/:id': 'edit'
    'los/:lo_id/exercises/:id': 'show'
