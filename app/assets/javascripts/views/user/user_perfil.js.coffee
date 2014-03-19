class Carrie.Views.UserPerfil extends Backbone.Marionette.ItemView
  template: 'user/perfil'

  events:
    'submit form': 'update'

  initialize: ->
    this.model = new Carrie.Models.UserRegistration
      id: Carrie.currentUser.get('_id')
      name: Carrie.currentUser.get('name')
      email: Carrie.currentUser.get('email')

    this.modelBinder = new Backbone.ModelBinder()

  onRender: ->
    this.modelBinder.bind(this.model, this.el)

  update: (e) ->
    e.preventDefault()

    $(@el).find('input.btn-primary').button('loading')
    $(@el).find('.alert-error').remove()
    $(@el).find('.help-block').remove()
    $(@el).find('.control-group.error').removeClass('error')


    @model.save @model.attributes,
      success: (user, response) =>
        $(@el).find('input.btn-primary').button('reset')
        Carrie.currentUser.set('name', user.get('name'))
        Carrie.currentUser.set('email', user.get('email'))
        Carrie.currentUser.set('gravatar', $.md5(user.get('email')))


        Carrie.Helpers.Notifications.Top.success('Seus dados foram atualizados!')
        Carrie.header_right_menu.show new Carrie.Views.AuthenticateHRM model: Carrie.currentUser
        Carrie.layouts.main.content.close()
        Backbone.history.navigate '/welcome', true

      error: (userSession, response) =>
        result = $.parseJSON(response.responseText)
        $(@el).find('form').prepend(Carrie.Helpers.Notifications.error("Não foi possível atualizar seus dados"))


        _(result.errors).each (errors, field) ->
          #console.log(errors)
          #console.log(field)
          $("\##{field}_group").addClass 'error'
          _(errors).each (error, i) ->
            $("\##{field}_group .controls").append(Carrie.Helpers.FormHelpers.fieldHelp(error))

        $(@el).find('input.btn-primary').button 'reset'
