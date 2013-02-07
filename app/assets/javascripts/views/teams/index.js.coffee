class Carrie.CompositeViews.Teams extends Backbone.Marionette.CompositeView
  tagName: 'section'
  template: 'teams/index'
  className: 'teams'
  itemView: Carrie.Views.Team

  events:
    'submit .form-search': 'search'

  initialize: ->
    @collection = new Carrie.Collections.Teams()
    @endless = new Carrie.Models.Endless
      root_url: '/api/teams'
      collection: @collection
      fecth_array: 'teams'

  onRender: ->
    @endless.load()

  search: (ev) ->
    ev.preventDefault()
    @endless.reload search: $(@el).find('.form-search input').val()
