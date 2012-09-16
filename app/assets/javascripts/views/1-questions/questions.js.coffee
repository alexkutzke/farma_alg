class Carrie.Views.Question extends Backbone.Marionette.ItemView
  template: 'exercises/question'
  tagName: 'article'

  onRender: ->
    @el.id = @model.get('id')
