class Carrie.Models.Answer extends Backbone.RelationalModel
  urlRoot: ->
    '/api/answers'

  paramRoot: 'answer'

  default:
    tip: ''

  toJSON: ->
    if @get('question').get('exercise_p')
      lo_id = @get('question').get('exercise_p').get('lo_p').get('id')
    else
      lo_id = @get('question').get('exercise').get('lo').get('id')
    
    if @get('question').get('exercise_p') 
      exercise_id = @get('question').get('exercise_p').get('id')
    else
      exercise_id = @get('question').get('exercise').get('id')

    response: @get('response')
    lang: @get('lang')    
    lo_id: lo_id
    exercise_id: exercise_id
    question_id: @get('question').get('id')
    tip: @get('tip')
    for_test: @get('for_test')
    team_id: @get('team_id')
