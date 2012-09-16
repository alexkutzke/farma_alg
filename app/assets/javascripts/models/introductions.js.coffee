class Carrie.Models.Introduction extends Backbone.RelationalModel
  urlRoot: ->
    '/api/los/' + @get('lo').get('id') + '/introductions/'

  paramRoot: 'introduction'

  defaults:
    'title': ''
    'content': ''

  toJSON: ->
    id: @get('id')
    title: @get('title')
    content: @get('content')
    available: @get('available')
    lo_id: @get('lo').get('id')
    updated_at: @get('updated_at')
    created_at: @get('created_at')

Carrie.Models.Introduction.setup()
