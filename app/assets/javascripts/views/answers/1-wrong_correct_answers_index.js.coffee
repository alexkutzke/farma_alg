class Carrie.CompositeViews.WrongCorrectAnswersIndex extends Backbone.Marionette.CompositeView
  tagName: 'section'
  template: 'answers/wrong_correct_answers_index'
  itemView: Carrie.Views.WrongCorrectAnswerItem
  itemViewContainer: 'tbody'

  initialize: ->
    @mapFilters()
    @endless = new Carrie.Models.Endless
       root_url: '/api/answers'
       collection: @collection
       fecth_array: 'answers'

    @loadFilters()
    @collection.on 'add', ->
      el = @el
      setTimeout ( ->
        MathJax.Hub.Queue(["Typeset",MathJax.Hub, el])
      ), 100
    , @

  onRender: ->
    @endless.load()
    @updatePageInfo()
    unless @visualSearch
      @search()
    MathJax.Hub.Queue(["Typeset",MathJax.Hub, @el])

  updatePageInfo: ->
    info = "Total de encontrados: #{@endless.get('total')}"
    $(@el).find('.pages-info').html(info)

  mapFilters: ->
    @map =
      respostas: 'correct'
      corretas: 'true'
      erradas: 'false'
      turma: 'team_id'
      oa: 'lo_id'
      aprendiz: 'user_id'
      exercicio: 'exercise_id'

  loadFilters: ->
    @params = {}
    @teams = new Carrie.Collections.TeamSearchAnswers()
    @teamsJSON = @teams.toJSON()

    @los = new Carrie.Collections.LoSearchAnswers()
    @learners = new Carrie.Collections.LearnerSearchAnswers()
    @exercises = new Carrie.Collections.ExerciseSearchAnswers()

  searchContains: (data, name) ->
    contains = false
    if data
      $.each  data, (index, el) =>
        $.each el, (key, value) =>
          if key == name
            contains = true

    return contains

  prepareParams: (data) ->
    params = {}
    $.each  data, (index, el) =>
      $.each el, (key, value) =>
        value = @map[value] if @map[value]
        key = @map[key] if @map[key]

        value =  @teams.where({label: value})[0].get('id') if key == 'team_id'

        if key == 'lo_id'
          lo = @los.where({label: value})[0]
          value = lo.get('id') if lo

        value =  @learners.where({label: value})[0].get('id') if key == 'user_id'
        value =  @exercises.where({label: value})[0].get('id') if key == 'exercise_id'

        params[key] = value

    return params

  updateLos: ->
    if @params['team_id']
      params = {team_id: @params['team_id']}
      @los.fetch
        async: false
        data: params
    else
      @los.fetch
        async: false

    @losJSON = @los.toJSON()

  updateLearners: ->
    if @params['team_id']
      params = {team_id: @params['team_id']}
      @learners.fetch
        async: false
        data: params
    else
      @learners.fetch
        async: false

    @learnersJSON = @learners.toJSON()

  updateExercises: ->
    if @params['lo_id']
      params = {id: @params['lo_id']}
      @exercises.fetch
        async: false
        data: params

    @exercisesJSON = @exercises.toJSON()

  search: ->
    @visualSearch = VS.init
      container : $(@el).find('.visual_search')
      query     : ''
      callbacks :
        search : (query, searchCollection) =>
          @params = @prepareParams searchCollection.facets()
          @endless.reload
            search: @params
          @updatePageInfo()

          #console.log(["query", searchCollection.facets(), query])

        # These are the facets that will be autocompleted in an empty input.
        facetMatches : (callback) =>
          facets = @visualSearch.searchQuery.facets()
          filters = []
          if not @searchContains facets , 'respostas'
            filters.push { value: 'respostas', label: 'Respostas' }

          if not @searchContains facets, 'turma'
            filters.push { value: 'turma', label: 'Turmas' }

          if not @searchContains facets, 'oa'
            filters.push { value: 'oa', label: 'OA' }

          if not @searchContains facets, 'aprendiz'
            filters.push { value: 'aprendiz', label: 'Aprendiz' }

          if not(@searchContains(facets, 'exercicio')) &&  @params['lo_id']
            filters.push { value: 'exercicio', label: 'Exercício' }

          callback(filters)

        # These are the values that match specific categories, autocompleted
        # in a category's input field.  searchTerm can be used to filter the
        # list on the server-side, prior to providing a list to the widget.
        valueMatches : (facet, searchTerm, callback) =>
          switch facet
            when 'respostas'
              callback([
                { value: 'corretas', label: 'Corretas' }
                { value: 'erradas', label: 'Erradas' }
              ])
            when 'turma'
              callback(@teamsJSON)
            when 'oa'
              @updateLos()
              callback(@losJSON)
            when 'aprendiz'
              @updateLearners()
              callback(@learnersJSON)
            when 'exercicio'
              @updateExercises()
              callback(@exercisesJSON)
             else
               #console.log('nothing')


