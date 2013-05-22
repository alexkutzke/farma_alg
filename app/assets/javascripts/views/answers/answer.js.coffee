# Answer for construct a exercise
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

      console.log @model
    else
      @template = 'answers/answer_empty'

  resp: ->
    if @model
     return @model.get('response')
    else
      return ""