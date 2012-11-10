class Carrie.Models.AnswerComment extends Backbone.RelationalModel
  urlRoot: ->
    "/api/answers/#{@get('answer').get('id')}/comments"

  defaults:
    'text': ''

  paramRoot: 'comment'

  toJSON: ->
    answer_id: @get('answer').get('id')
    text: @get('text')
    can_destroy: @get('can_destroy')
    user_name: @get('user_name') if @get('user_name')
    user_gravatar: @get('user_gravatar') if @get('user_gravatar')
    created_at_in_words: @get('created_at_in_words') if @get('created_at_in_words')
