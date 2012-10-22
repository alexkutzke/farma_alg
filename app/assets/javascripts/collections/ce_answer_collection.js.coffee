class Carrie.Collections.CEAnswers extends Backbone.Collection
  model: Carrie.Models.CEAnswer
  url: ->
    '/api/answers'

  initialize: ->
    Carrie.Utils.Loading @
