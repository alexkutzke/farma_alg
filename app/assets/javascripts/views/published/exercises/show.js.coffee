class Carrie.Published.Views.Exercise extends Backbone.Marionette.CompositeView
  template: 'published/exercises/show'
  tagName: 'article'
  itemView: Carrie.Published.Views.Question

  initialize: ->
    @collection = @model.get('questions')
    console.log(@collection)
    this

  onRender: ->
    MathJax.Hub.Queue(["Typeset",MathJax.Hub, @el])
