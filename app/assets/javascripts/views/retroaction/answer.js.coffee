class Carrie.Views.Retroaction.Answer extends Backbone.Marionette.ItemView
  template: 'retroaction/answer'

  initialize:->
    console.log @model
    @exerciseView = new Carrie.CompositeViews.Retroaction.Exercise
      model: @model.get('exercise')
      question :@model.get('question')
    @commentsView = new Carrie.CompositeViews.Retroaction.AnswerComments
      model: @model
      collection: @model.get('comments')

    $(@el).on 'hidden', =>
      @.close()

  onRender: ->
    $(@el).find('.modal-body .answers').html @exerciseView.render().el
    $(@el).find('.modal-body .comments').html @commentsView.render().el
    $(@el).find('.accordion-body').on 'hidden', (event) =>
      event.stopPropagation()

  onClose: ->
    @exerciseView.close()
    @commentsView.close()
