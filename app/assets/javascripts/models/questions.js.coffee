class Carrie.Models.Question extends Backbone.RelationalModel
  urlRoot: ->
    '/api/los/' + @get('exercise').get('lo').get('id') + '/exercises/' + @get('exercise').get('id') + '/questions'

  paramRoot: 'question'

  defaults:
    'title': ''
    'content': ''

  toJSON: ->
    id: @get('id')
    title: @get('title')
    content: @get('content')
    available: @get('available')
    lo_id: @get('exercise').get('lo').get('id')
    exercise_id: @get('exercise').get('id')

Carrie.Models.Exercise.setup()
