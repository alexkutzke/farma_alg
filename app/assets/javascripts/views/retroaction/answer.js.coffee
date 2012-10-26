class Carrie.Views.Retroaction.Answer extends Backbone.Marionette.ItemView
  template: 'retroaction/answer'

  initialize:->
    @exerciseView = new Carrie.CompositeViews.Retroaction.Exercise
      model: @model.get('exercise')

  onRender: ->
    $(@el).find('.modal-body').html @exerciseView.render().el
