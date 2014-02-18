class Carrie.Collections.Comments extends Backbone.Collection
  model: Carrie.Models.Comment
  url: ->
    "/api/comments"

  initialize: ->
    Carrie.Utils.Loading @

  #comparator: (answer) ->
  #  answer.get('created_at')
