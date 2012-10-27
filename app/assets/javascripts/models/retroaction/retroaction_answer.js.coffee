class Carrie.Models.RetroactionAnswer extends Backbone.RelationalModel
  urlRoot: ->
    '/api/retroaction_answers'

  paramRoot: 'retroaction_answer'

  default:
    tip: ''

  toJSON: ->
    response: @get('response')
    answer_id: @get('answer_id')
    question_id: @get('question_id')
    user_id: @get('user_id')
    tip: @get('tip')
