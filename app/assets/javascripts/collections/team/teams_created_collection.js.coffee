class Carrie.Collections.TeamsCreated extends Backbone.Collection
  model: Carrie.Models.TeamsCreated

  url: ->
    '/api/teams/created'

  initialize: ->
    @fetch()
