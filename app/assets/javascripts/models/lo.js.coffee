class Carrie.Models.Lo extends Backbone.RelationalModel
  urlRoot: '/api/los/'

  paramRoot: 'lo'

  defaults:
    'name': ''
    'description': ''
    'available': false

  relations: [{
    type: Backbone.HasMany
    key: 'introductions'
    relatedModel: 'Carrie.Models.Introduction'
    collectionType: 'Carrie.Collections.Introductions'
    reverseRelation: {
      key: 'lo'
    }
  },
  {
    type: Backbone.HasMany
    key: 'exercises'
    relatedModel: 'Carrie.Models.Exercise'
    collectionType: 'Carrie.Collections.Exercises'
    reverseRelation: {
      key: 'lo'
    }
  }
  ]

Carrie.Models.Lo.setup()
