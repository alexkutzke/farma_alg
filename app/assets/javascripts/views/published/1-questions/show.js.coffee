class Carrie.Published.Views.Question extends Backbone.Marionette.ItemView
  template: 'published/questions/show'
  tagName: 'article'

  onRender: ->
    MathJax.Hub.Queue(["Typeset",MathJax.Hub, @el])
