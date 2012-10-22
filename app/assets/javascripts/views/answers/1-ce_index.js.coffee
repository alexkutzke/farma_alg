class Carrie.CompositeViews.CEAnswerIndex extends Backbone.Marionette.CompositeView
  tagName: 'section'
  template: 'answers/ce_index'
  itemView: Carrie.Views.CEAnswerItem
  itemViewContainer: 'tbody'

  initialize: ->
    @loadFilters()
    @mapFilters()
    @endless = new Carrie.Models.Endless
       root_url: '/api/answers'
       collection: @collection
       fecth_array: 'answers'

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

  updatePageInfo: ->
    info = "Total de encontrados: #{@endless.get('total')}"
    $(@el).find('.pages-info').html(info)

  mapFilters: ->
    @map =
      respostas: 'correct'
      corretas: 'true'
      erradas: 'false'
      turmas: 'team_id'
      oa: 'lo_id'

  loadFilters: ->
    @params = {}
    @teams = new Carrie.Collections.TeamSearchAnswers()
    @teamsJSON = @teams.toJSON()

    @los = new Carrie.Collections.LoSearchAnswers()
    @losJSON = @los.toJSON()

  searchContains: (data, name) ->
    contains = false
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

          if not @searchContains facets, 'turmas'
            filters.push { value: 'turmas', label: 'Turmas' }

          if not @searchContains facets, 'oa'
            filters.push { value: 'oa', label: 'OA' }

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
            when 'turmas'
              callback(@teamsJSON)
            when 'oa'
              @updateLos()
              callback(@losJSON)
            else
              console.log('nothing')

