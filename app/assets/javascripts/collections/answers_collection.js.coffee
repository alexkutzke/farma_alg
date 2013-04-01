class Carrie.Collections.Answers extends Backbone.Collection
  model: Carrie.Models.Answer
  url: ->
    '/api/answers'

  initialize: ->
    Carrie.Utils.Loading(@)
