class Carrie.Views.Layouts.Main extends Backbone.Marionette.Layout
  template: 'layouts/main'
  regions:
    content: '#content'

Carrie.addInitializer ->
  Carrie.layouts.main = new Carrie.Views.Layouts.Main()
