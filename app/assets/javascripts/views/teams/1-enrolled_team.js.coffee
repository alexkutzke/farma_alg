class Carrie.Views.EnrolledTeam extends Backbone.Marionette.ItemView
  tagName: 'article'
  template: 'teams/enrolled_team'

  events:
    'click article.lo' : 'openLo'

  openLo: ->
    url = "/published/teams/#{@model.get('team_id')}/los/#{@model.get('id')}"
    Backbone.history.navigate(url, true)
