class Carrie.Views.CreateOrSaveIntroduction extends Backbone.Marionette.ItemView
  template: 'introductions/form'

  events:
    'submit form': 'create'

  initialize: ->
    if not @model
      @model = new Carrie.Models.Introduction({lo:@options.lo})

    this.modelBinder = new Backbone.ModelBinder()

  onRender: ->
    @modelBinder.bind(this.model, this.el)

  create: (ev) ->
    ev.preventDefault()

    Carrie.Utils.Alert.clear()

    @model.save @model.attributes,
      wait: true
      success: (lo, response) =>
        $(@el).find('input.btn-primary').button('reset')
        Backbone.history.navigate '/los/'+@options.lo.get('id')+'/introductions', true

        Carrie.Utils.Alert.success('Introdução criada com sucesso!', 3000)

      error: (lo, response) =>
        result = $.parseJSON(response.responseText)

        msg = Carrie.Helpers.Notifications.error('Existe erros no seu formulário')
        $(@el).find('form').before(msg)
        Carrie.Utils.Alert.showFormErrors(result.errors, @el)

        $(@el).find('input.btn-primary').button 'reset'
