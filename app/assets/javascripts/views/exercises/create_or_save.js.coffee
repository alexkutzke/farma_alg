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
    setTimeout ( ->
      $("#ckeditor").ckeditor({language: 'pt-br'})
    ), 100

  beforeClose: ->
    $(@el).find("textarea").ckeditorGet().destroy()

  create: (ev) ->
    ev.preventDefault()

    Carrie.Utils.Alert.clear()

    @model.set('content', CKEDITOR.instances.ckeditor.getData())

    @model.save @model.attributes,
      wait: true
      success: (model, response) =>
        $(@el).find('input.btn-primary').button('reset')
        Backbone.history.navigate "/los/#{@options.lo.get('id')}/exercises/#{@model.get('id')}", true
        Carrie.Utils.Alert.success('Exercício salvo com sucesso!', 3000)

      error: (model, response) =>
        result = $.parseJSON(response.responseText)

        msg = Carrie.Helpers.Notifications.error('Existe erros no seu formulário')
        $(@el).find('form').before(msg)
        Carrie.Utils.Alert.showFormErrors(result.errors, @el)

        $(@el).find('input.btn-primary').button 'reset'
