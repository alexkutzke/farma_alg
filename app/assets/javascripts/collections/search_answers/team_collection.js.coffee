class Carrie.Collections.TeamSearchAnswers extends Backbone.Collection
  model: Carrie.Models.TeamSearchAnswers
  url: '/api/teams/my_teams'

  initialize: ->
    @fetch
      async: false
