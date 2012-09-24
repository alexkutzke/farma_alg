class Carrie.Published.Models.Exercise extends Backbone.RelationalModel

  relations: [{
    type: Backbone.HasMany
    key: 'questions'
    relatedModel: 'Carrie.Published.Models.Question'
    collectionType: 'Carrie.Published.Collections.Questions'
    reverseRelation: {
      key: 'exercise'
    }
  }]
