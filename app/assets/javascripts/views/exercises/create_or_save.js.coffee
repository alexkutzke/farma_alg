class Carrie.Views.CreateOrSaveExercise extends Backbone.Marionette.ItemView
  template: 'exercises/form'

  events:
    'submit form': 'create'

  initialize: ->
    @model = new Carrie.Models.Exercise({lo:@options.lo}) if not @model
    this.modelBinder = new Backbone.ModelBinder()

  onRender: ->
    @modelBinder.bind(this.model, this.el)
    Carrie.CKEDITOR.show()

  beforeClose: ->
    $(@el).find("textarea").ckeditorGet().destroy()

  create: (ev) ->
    ev.preventDefault()
    Carrie.Helpers.Notifications.Form.clear()
    Carrie.Helpers.Notifications.Form.loadSubmit()

    # Get date from ckeditor and set in the model
    @model.set('content', CKEDITOR.instances.ckeditor.getData())

    @model.save @model.attributes,
      wait: true
      success: (model, response, options) =>
        Carrie.Helpers.Notifications.Form.resetSubmit()
        Backbone.history.navigate "/los/#{@options.lo.get('id')}/exercises/#{@model.get('id')}", true
        Carrie.Helpers.Notifications.Top.success 'Exercício salvo com sucesso!', 4000

      error: (model, response, options) =>
        result = $.parseJSON(response.responseText)

        Carrie.Helpers.Notifications.Form.before 'Existe erros no seu formulário'
        Carrie.Helpers.Notifications.Form.showErrors(result.errors, @el)
        Carrie.Helpers.Notifications.Form.resetSubmit()
