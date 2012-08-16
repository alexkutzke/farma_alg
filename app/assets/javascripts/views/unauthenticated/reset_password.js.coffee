Carrie.Views.Unauthenticated = Carrie.Views.Unauthenticated || {}

class Carrie.Views.Unauthenticated.ResetPassword extends Backbone.Marionette.ItemView
  template: 'unauthenticated/reset_password'

  events:
    'submit form': 'resetPassword'

  initialize: ->
    this.model = new Carrie.Models.UserPasswordReset reset_password_token: @model.reset_password_token
    this.modelBinder = new Backbone.ModelBinder()

  onRender: ->
    $('#unauthenticated-view-container ul').hide()
    this.modelBinder.bind(this.model, this.el)

  resetPassword: (e) ->
    self = this
    el = $(this.el)

    e.preventDefault()

    el.find('input.btn-primary').button('loading')
    el.find('.alert-error').remove()
    el.find('.alert-success').remove()
    el.find('.help-block').remove()
    el.find('.control-group.error').removeClass('error')

    this.model.save this.model.attributes,
      success: (user, response) ->
        window.location.href = '/'

      error: (user, response) ->
        result = $.parseJSON(response.responseText)

        if result.errors.reset_password_token
          el.find('form').prepend(Carrie.Helpers.Notifications.error('Token de autenticação inválido.'))
        else
          _(result.errors).each (errors, field) ->
            $("\##{field}_group").addClass 'error'
            _(errors).each (error, i) ->
              $("\##{field}_group .controls").append(Carrie.Helpers.FormHelpers.fieldHelp(error))

        el.find('input.btn-primary').button('reset')
