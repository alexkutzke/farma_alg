class Carrie.Models.Question extends Backbone.RelationalModel
  urlRoot: ->
    '/api/los/' + @get('exercise').get('lo').get('id') + '/exercises/' + @get('exercise').get('id') + '/questions'

  paramRoot: 'question'

  relations: [{
    type: Backbone.HasMany
    key: 'test_cases'
    relatedModel: 'Carrie.Models.TestCase'
    collectionType: 'Carrie.Collections.TestCases'
    reverseRelation: {
      key: 'question'
    }
  },
  {
    type: Backbone.HasMany
    key: 'answers'
    relatedModel: 'Carrie.Models.Answer'
    collectionType: 'Carrie.Collections.Answers'
    reverseRelation: {
      key: 'question'
    }
  }
  ]

  defaults:
    'title': ''
    'content': ''
    'comparation_type': 'expression'

  toJSON: ->
    id: @get('id')
    title: @get('title')
    content: @get('content')
    input: @get('input')
    output: @get('output')
    available: @get('available')
    languages: @get('languages')
    lo_id: @get('exercise').get('lo').get('id')
    exercise_id: @get('exercise').get('id')

Carrie.Models.Exercise.setup()
