class Carrie.Collections.TeamSearchAnswers extends Backbone.Collection
  model: Carrie.Models.TeamSearchAnswers
  url: '/api/teams/teams_for_search'

  initialize: ->
    @fetch
      async: false
