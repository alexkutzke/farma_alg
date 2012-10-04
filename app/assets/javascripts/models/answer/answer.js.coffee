class Carrie.Models.Answer extends Backbone.RelationalModel
  urlRoot: ->
    '/api/answers'

  paramRoot: 'answer'

  default:
    tip: ''

  toJSON: ->
    response: @get('response')
    question_id: @get('question').get('id')
    tip: @get('tip')
    for_test: @get('for_test')
