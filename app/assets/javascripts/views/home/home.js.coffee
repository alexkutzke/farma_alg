class Carrie.Views.HomeIndex extends Backbone.Marionette.ItemView
  template: 'home/index'
  className: 'row-fluid'
  regions:
    content: '#content'

  events:
    'submit form': 'create'
    'click a#lo-example-link': 'view'

  initialize: ->
    this.model = new Carrie.Models.Contact() if not @model
    this.modelBinder = new Backbone.ModelBinder()

  onRender: ->
    this.modelBinder.bind(this.model, this.el)

  view: (ev) ->
    ev.preventDefault()
    Backbone.history.navigate('/lo_example', true)

  create: (ev) ->
    ev.preventDefault()
    Carrie.Helpers.Notifications.Form.clear()
    Carrie.Helpers.Notifications.Form.loadSubmit()

    @model.save @model.attributes,
      wait: true
      success: (model, response, options) =>
        ev.target.reset()
        Carrie.Helpers.Notifications.Form.resetSubmit()
        Carrie.Helpers.Notifications.Top.success 'Mensagem enviada com sucesso!', 4000

      error: (model, response, options) =>
        result = $.parseJSON(response.responseText)

        Carrie.Helpers.Notifications.Form.before 'Existe erros no seu formulário'
        Carrie.Helpers.Notifications.Form.showErrors(result.errors, @el)
        Carrie.Helpers.Notifications.Form.resetSubmit()
