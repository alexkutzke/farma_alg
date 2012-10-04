class Carrie.Published.Views.Exercise extends Backbone.Marionette.CompositeView
  template: 'published/exercises/show'
  tagName: 'article'
  itemView: Carrie.Published.Views.Question

  events:
    'click a.reset-exercise' : 'clearLastAnswers'

  initialize: ->
    @collection = @model.get('questions')
    this

  onRender: ->
    MathJax.Hub.Queue(["Typeset",MathJax.Hub, @el])

  clearLastAnswers: (ev) ->
    ev.preventDefault()
    obj = new Carrie.Published.Models.ExerciseLastAnswersDelete
      lo_id: @model.get('lo').get('id')
      id: @model.get('id')

    obj.destroy
      success: =>
         _(@collection.models).each (question) ->
           question.unset('last_answer')
         @render()
