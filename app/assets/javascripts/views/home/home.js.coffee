class Carrie.Views.Layouts.Home extends Backbone.Marionette.ItemView
  template: 'home/index'
  className: 'row-fluid'
  regions:
    content: '#content'

Carrie.addInitializer ->
  Carrie.layouts.home = new Carrie.Views.Layouts.Home()
