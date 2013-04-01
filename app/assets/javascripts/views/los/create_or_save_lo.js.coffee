class Carrie.Views.CreateOrSaveLo extends Backbone.Marionette.ItemView
  template: 'los/form'

  events:
    'submit form': 'create'

  initialize: ->
    this.model = new Carrie.Models.Lo() if not @model
    this.modelBinder = new Backbone.ModelBinder()

  onRender: ->
    this.modelBinder.bind(this.model, this.el)

  create: (ev) ->
    ev.preventDefault()
    Carrie.Helpers.Notifications.Form.clear()
    Carrie.Helpers.Notifications.Form.loadSubmit()

    @model.save @model.attributes,
      wait: true
      success: (model, response, options) =>
        Carrie.Helpers.Notifications.Form.resetSubmit()

        Backbone.history.navigate '/los', true
        Carrie.Helpers.Notifications.Top.success 'OA salva com sucesso!', 4000

      error: (model, response, options) =>
        result = $.parseJSON(response.responseText)

        Carrie.Helpers.Notifications.Form.before 'Existe erros no seu formulário'
        Carrie.Helpers.Notifications.Form.showErrors(result.errors, @el)
        Carrie.Helpers.Notifications.Form.resetSubmit()
