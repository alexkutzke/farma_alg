class Carrie.Collections.TeamsEnrolled extends Backbone.Collection
  model: Carrie.Models.TeamsEnrolled

  url: ->
    '/api/teams/enrolled'

  initialize: ->
    @fetch()
