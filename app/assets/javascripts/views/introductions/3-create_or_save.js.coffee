class Carrie.Views.CreateOrSaveIntroduction extends Backbone.Marionette.ItemView
  template: 'introductions/form'

  events:
    'submit form': 'create'

  initialize: ->
    @model = new Carrie.Models.Introduction({lo:@options.lo}) if not @model
    this.modelBinder = new Backbone.ModelBinder()

  beforeClose: ->
    $(@el).find("textarea").ckeditorGet().destroy()

  onRender: ->
    @modelBinder.bind(this.model, this.el)
    Carrie.CKEDITOR.show()

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

        Backbone.history.navigate "/los/#{@options.lo.get('id')}/introductions", true
        Carrie.Helpers.Notifications.Top.success 'OA salva com sucesso!', 4000

      error: (model, response, options) =>
        result = $.parseJSON(response.responseText)

        Carrie.Helpers.Notifications.Form.before 'Existe erros no seu formulário'
        Carrie.Helpers.Notifications.Form.showErrors(result.errors, @el)
        Carrie.Helpers.Notifications.Form.resetSubmit()
