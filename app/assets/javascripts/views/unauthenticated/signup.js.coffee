Carrie.Views.Unauthenticated = Carrie.Views.Unauthenticated || {}

class Carrie.Views.Unauthenticated.Signup extends Backbone.Marionette.ItemView
  template: 'unauthenticated/signup'

  events:
    'submit form': 'signup'

  initialize: ->
    this.model = new Carrie.Models.UserRegistration()
    this.modelBinder = new Backbone.ModelBinder()

  onRender: ->
    this.modelBinder.bind(this.model, this.el)

  signup: (e) ->
    e.preventDefault()
    console.log('submit')
