class Carrie.Models.Retroaction.Answer extends Backbone.RelationalModel
  url: ->
    "/api/answers/#{@get('id')}/retroaction"

  initialize: ->
    @fetch
      async: false


  relations: [{
    type: Backbone.HasOne
    key: 'exercise'
    relatedModel: 'Carrie.Models.Retroaction.Exercise'
    reverseRelation: {
      key: 'answer'
      type: Backbone.HasOne
    }
  }]

Carrie.Models.Exercise.setup()
