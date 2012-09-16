class Carrie.CompositeViews.Los extends Backbone.Marionette.CompositeView
  tagName: 'section'
  template: 'los/index'
  itemView: Carrie.Views.Lo

  events:
    'click #new_lo' : 'new_lo'

  new_lo: (ev) ->
    ev.preventDefault()
    Backbone.history.navigate('/los/new', true)

  onRender: ->
    @el.id = 'los'

  #appendHtml: (collectionView, itemView, index) ->
  #  $(@el).append(itemView.el)
