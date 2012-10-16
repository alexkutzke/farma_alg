class Carrie.CompositeViews.Enrolled extends Backbone.Marionette.CompositeView
  tagName: 'section'
  template: 'teams/enrolled'
  className: 'teams'
  itemView: Carrie.CompositeViews.EachEnrolled

  events: ->
    'click #view-all': 'viewAll'

  viewAll: (ev) ->
    ev.preventDefault()
    Backbone.history.navigate("/teams", true)

