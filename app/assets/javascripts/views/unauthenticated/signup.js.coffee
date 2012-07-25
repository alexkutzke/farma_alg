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

    $(@el).find('input.btn-primary').button('loading')
    $(@el).find('.alert-error').remove()
    $(@el).find('.help-block').remove()
    $(@el).find('.control-group.error').removeClass('error')


    @model.save @model.attributes,
      success: (userSession, response) =>
        console.log('sucess')
        $(@el).find('input.btn-primary').button('reset')
        Carrie.currentUser = new Carrie.Models.User(response)
        Carrie.vent.trigger("authentication:logged_in")

      error: (userSession, response) =>
        result = $.parseJSON(response.responseText)
        $(@el).find('form').prepend(Carrie.Helpers.Notifications.error("Não foi possível fazer o cadastro."))


        _(result.errors).each (errors, field) ->
          console.log(errors)
          console.log(field)
          $("\##{field}_group").addClass 'error'
          _(errors).each (error, i) ->
            $("\##{field}_group .controls").append(Carrie.Helpers.FormHelpers.fieldHelp(error))

        $(@el).find('input.btn-primary').button 'reset'
