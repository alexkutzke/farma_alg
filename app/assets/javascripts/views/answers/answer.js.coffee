class Carrie.Views.Answer extends Backbone.Marionette.ItemView
  template: null

  tagName: 'div'

  initialize: ->
    if @model
      if not @model.get('correct')
        @model.set('classname', 'wrong')
        @model.set('title', 'Incorreto')
      else
        @model.set('classname', 'right')
        @model.set('title', 'Correto')

      @template = 'answers/answer'
    else
      @template = 'answers/answer_empty'

  onRender: ->
    MathJax.Hub.Queue(["Typeset",MathJax.Hub, @el])
