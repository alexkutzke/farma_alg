class Carrie.Models.Exercise extends Backbone.RelationalModel
  urlRoot: ->
    '/api/los/' + @get('lo').get('id') + '/exercises/'

  paramRoot: 'exercise'

  relations: [{
    type: Backbone.HasMany
    key: 'questions'
    relatedModel: 'Carrie.Models.Question'
    collectionType: 'Carrie.Collections.Questions'
    reverseRelation: {
      key: 'exercise'
    }
  }]

  defaults:
    'title': ''
    'content': ''

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

Carrie.Models.Exercise.setup()
