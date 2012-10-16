class Carrie.Collections.Teams extends Backbone.Collection
  model: Carrie.Models.Team

  url: '/api/teams'

  initialize: ->
    @fetch()
