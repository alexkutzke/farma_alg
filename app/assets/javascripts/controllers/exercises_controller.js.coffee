class Carrie.Routers.Exercises extends Backbone.Marionette.AppRouter
  appRoutes:
    'los/:lo_id/exercises': 'index'
    'los/:lo_id/exercises/new': 'new'
    'los/:lo_id/exercises/edit/:id': 'edit'
    'los/:lo_id/exercises/:id': 'show'

class Carrie.Controllers.Exercises

  index: (lo_id) ->
     Carrie.Helpers.Session.Exists
      func: =>
        Carrie.Utils.Menu.highlight 'los-link'
        lo = @findLo(lo_id)

        Carrie.layouts.main.loadBreadcrumb
          1: name: 'Objetos de Aprendizagem', url: '/los'
          2: name: "Exercícios do OA #{lo.get('name')}", url: ''

        lo.get('exercises').fetch
          wait: true
          success: (collection, response, options) =>
            index = new Carrie.CompositeViews.ExerciseIndex
              collection: lo.get('exercises')
              model: lo

            Carrie.layouts.main.content.show index
          error: (model, response, options)->
            Carrie.Helpers.Notifications.Flash.error('Problema para carregar os exercícios')

  new: (lo_id) ->
    Carrie.Helpers.Session.Exists
      func: =>
        Carrie.Utils.Menu.highlight 'los-link'
        lo = @findLo(lo_id)

        Carrie.layouts.main.loadBreadcrumb
          1: name: 'Objetos de Aprendizagem', url: '/los'
          2: name: "Exercícios do OA #{lo.get('name')}", url: "/los/#{lo.get('id')}/exercises"
          3: name: 'novo', url: ''

        Carrie.layouts.main.content.show new Carrie.Views.CreateOrSaveExercise(lo: lo)

  edit: (lo_id, id) ->
     Carrie.Helpers.Session.Exists
      func: =>
        Carrie.Utils.Menu.highlight 'los-link'
        lo = @findLo(lo_id)
        exercise = @findExer(lo, id)

        exercise.fetch
          success: (model, response, options) =>
            Carrie.layouts.main.loadBreadcrumb
              1: name: 'Objetos de Aprendizagem', url: '/los'
              2: name: "Exercícios do OA #{lo.get('name')}", url: "/los/#{lo.get('id')}/exercises"
              3: name: "Editar exercício #{model.get('title')}", url: ''

            Carrie.layouts.main.content.show new Carrie.Views.CreateOrSaveExercise(lo: lo, model: model)
          error: (model, response, options)->
            Carrie.Helpers.Notifications.Flash.error('Exercício não encontrado')

  show: (lo_id, id) ->
    Carrie.Helpers.Session.Exists
      func: =>
        Carrie.Utils.Menu.highlight 'los-link'
        lo = @findLo(lo_id)
        exercise = @findExer(lo, id)

        exercise.fetch
          success: (model, response, options) =>
            Carrie.layouts.main.loadBreadcrumb
              1: name: 'Objetos de Aprendizagem', url: '/los'
              2: name: "Exercícios do OA #{lo.get('name')}", url: "/los/#{lo.get('id')}/exercises"
              3: name: "Visualizando exercício #{model.get('title')}", url: ''

            Carrie.layouts.main.content.show new Carrie.CompositeViews.ExerciseShow(lo: lo, model: exercise)
          error: (model, response, options)->
            Carrie.Helpers.Notifications.Flash.error('Exercício não encontrado')

  findLo: (id) ->
    lo = Carrie.Models.Lo.findOrCreate(id)
    if not lo
      lo = new Carrie.Models.Lo({id: id})
      lo.fetch
        async: false
        error: (model, response, options) ->
          Carrie.Helpers.Notifications.Flash.error('Objeto de aprendizagem não encontrado')
    return lo

  findExer: (lo, id) ->
    exer = Carrie.Models.Exercise.findOrCreate(id)
    exer = new Carrie.Models.Exercise({lo: lo, id: id}) if not exer
    return exer
