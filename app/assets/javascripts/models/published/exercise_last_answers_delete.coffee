class Carrie.Published.Models.ExerciseLastAnswersDelete extends Backbone.RelationalModel
  url: ->
    "/api/los/#{@get('lo_id')}/exercises/#{@get('id')}/delete_last_answers"

  paramRoot: 'exercise'

  toJSON: ->
    id: @get('id')
    question_id: @get('question').get('id')
