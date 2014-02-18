class Carrie.CompositeViews.Retroaction.AnswerComments extends Backbone.Marionette.CompositeView
  tagName: 'section'
  template: 'retroaction/comments'
  itemView: Carrie.Views.Retroaction.AnswerComment
  itemViewContainer: '.comments-list'
