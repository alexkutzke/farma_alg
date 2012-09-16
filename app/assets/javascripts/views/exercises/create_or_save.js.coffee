class Carrie.Views.CreateOrSaveExercise extends Backbone.Marionette.ItemView
  template: 'exercises/form'

  events:
    'submit form': 'create'

  initialize: ->
    if not @model
      @model = new Carrie.Models.Exercise({lo:@options.lo})

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
        Backbone.history.navigate '/los/'+@options.lo.get('id')+'/exercises/'+@model.get('id'), true

        Carrie.Utils.Alert.success('Exercício salvo com sucesso!', 3000)

      error: (lo, response) =>
        result = $.parseJSON(response.responseText)

        Carrie.Utils.Alert.error('Existe erros no seu formulário')
        Carrie.Utils.Alert.showFormErrors(result.errors)

        $(@el).find('input.btn-primary').button 'reset'
