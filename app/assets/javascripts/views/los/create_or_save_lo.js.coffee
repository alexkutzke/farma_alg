class Carrie.Views.CreateOrSaveLo extends Backbone.Marionette.ItemView
  template: 'los/form'

  events:
    'submit form': 'create'

  initialize: ->
    if not @model
      this.model = new Carrie.Models.Lo()
    this.modelBinder = new Backbone.ModelBinder()

  onRender: ->
    this.modelBinder.bind(this.model, this.el)

  create: (ev) ->
    ev.preventDefault()

    Carrie.Utils.Alert.clear()

    @model.save @model.attributes,
      wait: true
      success: (lo, response) =>
        #@model.set('id', response.id) if response # verificar necessidade
        $(@el).find('input.btn-primary').button('reset')
        Backbone.history.navigate '/los', true

        Carrie.Utils.Alert.success('OA salva com sucesso!', 3000)

      error: (lo, response) =>
        result = $.parseJSON(response.responseText)

        msg = Carrie.Helpers.Notifications.error('Existe erros no seu formulário')
        $(@el).find('form').before(msg)
        Carrie.Utils.Alert.showFormErrors(result.errors, @el)

        $(@el).find('input.btn-primary').button 'reset'
