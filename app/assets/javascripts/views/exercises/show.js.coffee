class Carrie.CompositeViews.ExerciseShow extends Backbone.Marionette.CompositeView
  tagName: 'section'
  template: 'exercises/show'
  itemView: Carrie.Views.Question

  initialize: ->
    console.log(@model.get('questions'))
    @collection = @model.get('questions')

  onRender: ->
    @el.id = @model.get('id')
    $(@el).find('span i').tooltip()
