class Carrie.Published.Models.Lo extends Backbone.RelationalModel
  urlRoot: ->
    if @get('team_id')
      "/api/published/teams/#{@get('team_id')}/los"
    else
      "/api/published/los"

  paramRoot: 'lo'

  relations: [{
    type: Backbone.HasMany
    key: 'introductions'
    relatedModel: 'Carrie.Published.Models.Introduction'
    collectionType: 'Carrie.Published.Collections.Introductions'
    reverseRelation: {
      key: 'lo_p'
    }
  },
  {
    type: Backbone.HasMany
    key: 'exercises'
    relatedModel: 'Carrie.Published.Models.Exercise'
    collectionType: 'Carrie.Published.Collections.Exercises'
    reverseRelation: {
      key: 'lo_p'
    }
  }
  ]

Carrie.Models.Lo.setup()
