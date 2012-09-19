class Carrie.Views.CreateOrSaveQuestion extends Backbone.Marionette.ItemView
  template: 'questions/form'

  events:
    'submit form': 'create'
    'click .btn-cancel': 'cancel'

  initialize: ->
    if not @model
      @model = new Carrie.Models.Question
        exercise: @options.exercise
    else
      @editing = true

    @modelBinder = new Backbone.ModelBinder()

  onRender: ->
    @modelBinder.bind(this.model, this.el)

  cancel: (ev) ->
    ev.preventDefault()
    if @editing
      @modelBinder.unbind()
      @model.fetch(async:false)
      @options.view.render()
    else
      $('#new_question').html('')

  create: (ev) ->
    ev.preventDefault()

    Carrie.Utils.Alert.clear(@el)

    @model.save @model.attributes,
      success: (model, response) =>
        $(@el).find('input.btn-primary').button('reset')
        Carrie.Utils.Alert.success('Questão salva com sucesso!', 3000)

        if @editing
          @options.view.render()
        else
          @model.set('id', response._id) if response
          view = new Carrie.Views.Question({model: @model})
          $('#new_question').after view.render().el
          $('#new_question').html('')

      error: (model, response) =>
        result = $.parseJSON(response.responseText)

        msg = Carrie.Helpers.Notifications.error('Existe erros no seu formulário')
        $(@el).find('form').before(msg)
        Carrie.Utils.Alert.showFormErrors(result.errors, @el)

        $(@el).find('input.btn-primary').button 'reset'
