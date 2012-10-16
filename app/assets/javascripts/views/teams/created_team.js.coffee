class Carrie.CompositeViews.TeamsCreated extends Backbone.Marionette.CompositeView
  tagName: 'section'
  template: 'teams/created'
  itemView: Carrie.Views.TeamShow

  events:
    'click #new_team' : 'new'

  new: (ev) ->
    ev.preventDefault()
    Backbone.history.navigate("/teams/new", true)
