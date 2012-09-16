class Carrie.Routers.ExerciseController

  index: (lo_id) ->
    lo = @find_lo(lo_id)
    @setBreadcrumb(lo)
    Carrie.layouts.main.addBreadcrumb('Exercícios do OA ' + lo.get('name'), '', true)

    lo.get('exercises').fetch
      wait: true
      success: (collection, response) =>
        index = new Carrie.CompositeViews.ExerciseIndex
          collection: lo.get('exercises')
          model: lo
        Carrie.layouts.main.content.show index

      error: (model, response)->
        console.log(response)
        Carrie.Utils.Alert.error('Problema para carregar os exercícios')

  new: (lo_id) ->
    lo = @find_lo(lo_id)

    @setBreadcrumb(lo)
    Carrie.layouts.main.addBreadcrumb('Exercícios do OA ' + lo.get('name'), '/los/' + lo.get('id') + '/exercises')
    Carrie.layouts.main.addBreadcrumb('novo', '', true)

    Carrie.layouts.main.content.show new Carrie.Views.CreateOrSaveExercise(lo: lo)

  edit: (lo_id, id) ->
    lo = @find_lo(lo_id)

    exercise = new @find_exer(lo, id)

    exercise.fetch
      success: (model, response) =>
        @setBreadcrumb(lo)
        bread = 'Exercícios do OA ' + lo.get('name')
        Carrie.layouts.main.addBreadcrumb(bread, '/los/' + lo.get('id') + '/exercises')
        Carrie.layouts.main.addBreadcrumb('Editar exercício ' + model.get('title') , '', true)

        Carrie.layouts.main.content.show new Carrie.Views.CreateOrSaveExercise(lo: lo, model: model)
      error: (model, response)->
        Carrie.Utils.Alert.error('Exercício não encontrado')

  show: (lo_id, id) ->
    lo = @find_lo(lo_id)
    exercise = new @find_exer(lo, id)

    @setBreadcrumb(lo)
    bread = 'Exercícios do OA ' + lo.get('name')
    Carrie.layouts.main.addBreadcrumb(bread, '/los/' + lo.get('id') + '/exercises')
    Carrie.layouts.main.addBreadcrumb('Visualizando exercício ' + exercise.get('title') , '', true)

    Carrie.layouts.main.content.show new Carrie.CompositeViews.ExerciseShow(lo: lo, model: exercise)


  ## Private Methods
  find_lo: (id) ->
    lo = Carrie.Models.Lo.findOrCreate(id)

    if not lo
      lo = new Carrie.Models.Lo({id: id})
      lo.fetch
        async: false
        error: (model, response)->
          Carrie.Utils.Alert.error('Objeto de aprendizagem não encontrado')

    return lo

  find_exer: (lo, id) ->
    exer = Carrie.Models.Exercise.findOrCreate(id)

    if not exer
      exer = new Carrie.Models.Exercise({lo: lo, id: id})
      exer.fetch
        async: false
        error: (model, response)->
          Carrie.Utils.Alert.error('Exercício não encontrada')

    return exer

  setBreadcrumb: (model) ->
    $('#los-link').parent().siblings().removeClass('active')
    $('#los-link').parent().addClass('active')

    Carrie.layouts.main.reloadBreadcrumb()
    Carrie.layouts.main.addBreadcrumb('Objetos de Aprendizagem', '/los')
