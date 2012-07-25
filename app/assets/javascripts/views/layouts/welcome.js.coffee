class Carrie.Views.Layouts.Welcome extends Backbone.Marionette.Layout
  template: 'layouts/welcome'

  onRender: ->
    console.log(Carrie.currentUser.toJSON().gravatar)
    $(@el).html(HandlebarsTemplates[@template](Carrie.currentUser.toJSON()))

Carrie.addInitializer ->
  Carrie.layouts.welcome = new Carrie.Views.Layouts.Welcome()
