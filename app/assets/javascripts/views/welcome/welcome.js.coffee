class Carrie.Views.Welcome extends Backbone.Marionette.ItemView
  template: 'shared/welcome'

  #events:
    #'click .btn-sign-out' : 'sessionDestroy'

  initialize: ->
    $(@el).html(HandlebarsTemplates[@template](@model.toJSON()))

  # Verify crsf update after session destroy
  # it doesn't work correct
  sessionDestroy: (e) ->
    $.ajax
      type: 'DELETE'
      url:  '/users/sign_out.json'
      beforeSend: (xhr) ->
        xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
      success: (data) =>
        console.log(data)
        $(@el).find('.btn-sign-out').tooltip('hide')
        Carrie.main.show new Carrie.Views.Layouts.Unauthenticated()
        Carrie.currentUser = null
        $('#main').prepend(Carrie.Helpers.Notifications.success('Logout realizado com sucesso.'))
      error: (e) ->
        $('#main').prepend(Carrie.Helpers.Notifications.error('Não foi possível fazer o logout'))

    false #prevent Default is not working here

  onRender: ->
    $(@el).find('.btn-sign-out').tooltip
      placement: 'bottom'
