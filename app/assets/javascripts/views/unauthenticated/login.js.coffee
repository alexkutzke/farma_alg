Carrie.Views.Unauthenticated = Carrie.Views.Unauthenticated || {}

class Carrie.Views.Unauthenticated.Login extends Backbone.Marionette.ItemView
  template: 'unauthenticated/login'

  events:
    'submit form': 'login'

  initialize: ->
    this.model = new Carrie.Models.UserSession()
    this.modelBinder = new Backbone.ModelBinder()

  onRender: ->
    this.modelBinder.bind(this.model, this.el)

  login: (e) ->
    el = $(this.el)

    e.preventDefault()

    el.find('input.btn-primary').button('loading')
    el.find('.alert-error').remove()

    this.model.save this.model.attributes,
      success: (userSession, response) ->
        el.find('input.btn-primary').button('reset')
        Carrie.currentUser = new Carrie.Models.User(response)
        $('#main').prepend(Carrie.Helpers.Notifications.success('Seja bem-vindo ao sistema.'))
        Carrie.vent.trigger("authentication:logged_in")
        Backbone.history.navigate '', false

      error: (userSession, response) ->
        result = $.parseJSON(response.responseText)
        el.find('form').prepend(Carrie.Helpers.Notifications.error(result.error))
        el.find('input.btn-primary').button('reset')
