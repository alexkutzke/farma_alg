class Carrie.Published.Views.LoPaginator extends Backbone.Marionette.ItemView
  template: 'paginator/lo_published'
  tagName: 'div'
  className: 'lo-paginator pagination pagination-centered'

  initialize: ->
    @model.bind 'reset', @render, this
    @length = @model.get('pages_count')
    @page = 0
    @page = @options.page unless (@options.page < 0 || @options.page >= @length)
    @parentView = @options.parentView

  events:
    'change #page-select': 'changePage'
    'click #next-page': 'nextPage'
    'click #prev-page': 'prevPage'
    'click #last-page': 'lastPage'
    'click #first-page': 'firstPage'

  changePage: (ev) ->
    ev.preventDefault()
    @page = parseInt($(ev.target).val())
    @showPage()

  firstPage: (ev) ->
    ev.preventDefault()
    @page = 0
    @showPage()

  lastPage: (ev) ->
    ev.preventDefault()
    @page = @length-1
    @showPage()

  nextPage: (ev) ->
    ev.preventDefault()
    if @page+1 < @length
      @page += 1
      @showPage()

  prevPage: (ev) ->
    ev.preventDefault()
    if @page > 0
      @page -= 1
      @showPage()

  modelType: ->
    $(@el).find('select#page-select option:selected').data('type')

  pageCollection: ->
    $(@el).find('select#page-select option:selected').data('page-collection')

  showPage: (type) ->
    $(@el).find('select#page-select').val(@page)

    @setBreadcrumb()

    if @modelType() is 'introduction'
      view = new Carrie.Published.Views.Introduction
        model: @model.get('introductions').at(@pageCollection())
    else
      view = new Carrie.Published.Views.Exercise
        model: @model.get('exercises').at(@pageCollection())

    $(@parentView.el).find('section.page').html(view.render().el)

  setBreadcrumb: ->
    Backbone.history.navigate("/published/los/#{@model.get('id')}/pages/#{@page+1}", false)

    Carrie.layouts.main.reloadBreadcrumb()
    bread = "Objeto de aprendizagem #{@model.get('name')} / #{@model.get('pages')[@page].page_name}"
    Carrie.layouts.main.addBreadcrumb(bread, '', true)

  onRender: ->
    @showPage()
