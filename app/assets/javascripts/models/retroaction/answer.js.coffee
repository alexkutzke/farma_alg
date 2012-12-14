class Carrie.Models.Retroaction.Answer extends Backbone.RelationalModel
  url: ->
    "/api/answers/#{@get('id')}/retroaction"

  relations: [{
    type: Backbone.HasOne
    key: 'exercise'
    relatedModel: 'Carrie.Models.Retroaction.Exercise'
    reverseRelation: {
      key: 'answer'
      type: Backbone.HasOne
    }
  },{
    type: Backbone.HasMany
    key: 'comments'
    relatedModel: 'Carrie.Models.AnswerComment'
    collectionType: 'Carrie.Collections.AnswerComments'
    reverseRelation: {
      key: 'answer'
    }
  }]

Carrie.Models.Exercise.setup()
