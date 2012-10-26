class Carrie.Models.Retroaction.Exercise extends Backbone.RelationalModel

  relations: [{
    type: Backbone.HasMany
    key: 'questions'
    relatedModel: 'Carrie.Models.Retroaction.Question'
    collectionType: 'Carrie.Collections.Retroaction.Questions'
    reverseRelation: {
      key: 'exercise'
    }
  }]

Carrie.Models.Exercise.setup()
