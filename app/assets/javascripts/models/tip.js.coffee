class Carrie.Models.Tip extends Backbone.RelationalModel
  urlRoot: ->
    exer = @get('question').get('exercise')
    '/api/los/' + exer.get('lo').get('id') + '/exercises/' + exer.get('id') + '/questions/' + @get('question').get('id') + '/tips'

  paramRoot: 'tip'

  defaults:
    'content': ''
    'number_of_tries': '1'

  toJSON: ->
    id: @get('id')
    content: @get('content')
    number_of_tries: @get('number_of_tries')
    lo_id: @get('question').get('exercise').get('lo').get('id')
    exercise_id: @get('question').get('exercise').get('id')
    question_id: @get('question').get('id')

Carrie.Models.Tip.setup()
