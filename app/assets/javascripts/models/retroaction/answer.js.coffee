class Carrie.Models.Retroaction.Answer extends Backbone.RelationalModel
  url: ->
    "/api/answers/#{@get('id')}/retroaction"

  relations: [{
    type: Backbone.HasOne
    key: 'exercise'
    relatedModel: 'Carrie.Models.Retroaction.Exercise'
    reverseRelation: {
      key: 'answer'
    }
  }]

Carrie.Models.Exercise.setup()
