class Carrie.Collections.WrongCorrectAnswers extends Backbone.Collection
  model: Carrie.Models.WrongCorrectAnswer
  url: ->
    '/api/answers'

  initialize: ->
    Carrie.Utils.Loading @
