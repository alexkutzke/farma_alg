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

    this.modelBinder = new Backbone.ModelBinder()

  onRender: ->
    @modelBinder.bind(this.model, this.el)

  cancel: (ev) ->
    ev.preventDefault()
    if @editing
      @modelBinder.unbind()
      @model.fetch(async:false)
      q = new Carrie.Views.Question model: @model
      $(@el).parent().html(q.render().el)
    else
      $('#new_question').html('')

  create: (ev) ->
    ev.preventDefault()

    Carrie.Utils.Alert.clear(@el)

    @model.save @model.attributes,
      wait: true
      success: (model, response) =>
        $(@el).find('input.btn-primary').button('reset')
        Carrie.Utils.Alert.success('Questão salva com sucesso!', 3000)

        @model.set('id', response._id) if response

        q = new Carrie.Views.Question({model: @model})

        if @editing
          $(@el).parent().html(q.render().el)
        else
          $('#new_question').after(q.render().el)
          $('#new_question').html('')

      error: (model, response) =>
        result = $.parseJSON(response.responseText)

        Carrie.Utils.Alert.error('Existe erros no seu formulário')
        Carrie.Utils.Alert.showFormErrors(result.errors)

        $(@el).find('input.btn-primary').button 'reset'
