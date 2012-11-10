class Carrie.Views.Retroaction.Answer extends Backbone.Marionette.ItemView
  template: 'retroaction/answer'

  initialize:->
    @exerciseView = new Carrie.CompositeViews.Retroaction.Exercise
      model: @model.get('exercise')
    @commentsView = new Carrie.CompositeViews.Retroaction.AnswerComments
      model: @model
      collection: @model.get('comments')
    @beforeClose()

  onRender: ->
    $(@el).find('.modal-body .answers').html @exerciseView.render().el
    $(@el).find('.modal-body .comments').html @commentsView.render().el

  beforeClose: ->
    $(@el).on 'hide', =>
      @exerciseView.close()
      @commentsView.close()
