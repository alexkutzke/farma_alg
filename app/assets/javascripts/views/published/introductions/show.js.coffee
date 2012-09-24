class Carrie.Published.Views.Introduction extends Backbone.Marionette.ItemView
  template: 'published/introductions/show'
  tagName: 'article'

  onRender: ->
    MathJax.Hub.Queue(["Typeset",MathJax.Hub, @el])
