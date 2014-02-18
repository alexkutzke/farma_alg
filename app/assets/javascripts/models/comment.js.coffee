class Carrie.Models.Comment extends Backbone.RelationalModel
  urlRoot: ->
    "/api/comments"

  defaults:
    'text': ''

  paramRoot: 'comment'

#  toJSON: ->
#    text: @get('text')
#    user_name: @get('user_name') if @get('user_name')
#    user_gravatar: @get('user_gravatar') if @get('user_gravatar')
#    created_at_in_words: @get('created_at_in_words') if @get('created_at_in_words')