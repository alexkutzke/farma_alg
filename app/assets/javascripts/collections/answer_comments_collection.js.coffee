class Carrie.Collections.AnswerComments extends Backbone.Collection
  model: Carrie.Models.AnswerComment
  url: ->
    "/api/answers/#{@answer.get('id')}/comments"

  initialize: ->
    Carrie.Utils.Loading @

  #comparator: (answer) ->
  #  answer.get('created_at')
