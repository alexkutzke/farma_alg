class Carrie.CompositeViews.Teams extends Backbone.Marionette.CompositeView
  tagName: 'section'
  template: 'teams/index'
  className: 'teams'
  itemView: Carrie.Views.Team

  initialize: ->
    @collection = new Carrie.Collections.Teams()
    @endless = new Carrie.Models.Endless
      root_url: '/api/teams'
      collection: @collection
      fecth_array: 'teams'

  onRender: ->
    @endless.load()
