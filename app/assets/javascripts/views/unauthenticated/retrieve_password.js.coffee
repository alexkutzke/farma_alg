Carrie.Views.Unauthenticated = Carrie.Views.Unauthenticated || {}

class Carrie.Views.Unauthenticated.RetrievePassword extends Backbone.Marionette.ItemView
  template: 'unauthenticated/retrieve_password'

  events:
    'submit form': 'retrievePassword'

  initialize: ->
    this.model = new Carrie.Models.UserPasswordRecovery()
    this.modelBinder = new Backbone.ModelBinder()

  onRender: ->
    this.modelBinder.bind(this.model, this.el)

  retrievePassword: (e) ->
    self = this
    el = $(this.el)

    e.preventDefault()

    el.find('input.btn-primary').button('loading')
    el.find('.alert-error').remove()
    el.find('.alert-success').remove()

    this.model.save this.model.attributes,
      success: (userSession, response) ->
        msg = "Instruções sobre como redefinir sua senha foram enviado para sem email.
               Por favor, verifique seu e-mail para obtê-las."
        el.find('form').prepend Carrie.Helpers.Notifications.success(msg)
        el.find('input.btn-primary').button('reset')

      error: (userSession, response) ->
        msg = "Email não encontrado."
        el.find('form').prepend Carrie.Helpers.Notifications.error(msg)
        el.find('input.btn-primary').button('reset')
