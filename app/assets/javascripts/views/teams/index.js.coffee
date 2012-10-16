class Carrie.CompositeViews.Teams extends Backbone.Marionette.CompositeView
  tagName: 'section'
  template: 'teams/index'
  className: 'teams'
  itemView: Carrie.Views.Team
