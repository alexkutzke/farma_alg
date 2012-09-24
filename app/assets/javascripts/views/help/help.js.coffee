class Carrie.Views.Help extends Backbone.Marionette.ItemView
  template: 'help/help'
  tagName: 'section'
  className: 'help'

  onRender: ->
    MathJax.Hub.Queue(["Typeset",MathJax.Hub, @el])
