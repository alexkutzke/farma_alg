class Carrie.Views.EnrolledTeam extends Backbone.Marionette.ItemView
  tagName: 'article'
  template: 'teams/enrolled_team'

  events:
    'click article.lo' : 'openLo'

  initialize: ->
    @team_id = @model.get('team_id')

  openLo: ->
    url = "/published/teams/#{@team_id}/los/#{@model.get('id')}"
    Backbone.history.navigate(url, true)
