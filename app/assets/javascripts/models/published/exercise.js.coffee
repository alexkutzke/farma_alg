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

  toJSON: ->
    id: @get('id')
    title: @get('title')
    content: @get('content')
    available: @get('available')
    lo_id: @get('lo').get('id')
    updated_at: @get('updated_at')
    created_at: @get('created_at')
    questions: @get('questions').toJSON()
    questions_attributes: @get('questions_attributes')

Carrie.Published.Models.Exercise.setup()