class Carrie.CompositeViews.Retroaction.Exercise extends Backbone.Marionette.CompositeView
  tagName: 'section'
  template: 'retroaction/exercise'
  itemView: Carrie.Views.Retroaction.Question

  initialize: ->
    @collection = @model.get('questions')
