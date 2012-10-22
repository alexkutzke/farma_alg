class Carrie.Models.Answer extends Backbone.RelationalModel
  urlRoot: ->
    '/api/answers'

  paramRoot: 'answer'

  default:
    tip: ''

  toJSON: ->
    response: @get('response')
    lo_id: @get('question').get('exercise').get('lo').get('id')
    exercise_id: @get('question').get('exercise').get('id')
    question_id: @get('question').get('id')
    tip: @get('tip')
    for_test: @get('for_test')
    team_id: @get('team_id')
