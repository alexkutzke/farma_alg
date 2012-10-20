class Carrie.Views.CreateOrSaveQuestion extends Backbone.Marionette.ItemView
  template: 'questions/form'

  events:
    'submit form': 'create'
    'click .btn-cancel': 'cancel'

  initialize: ->
    if not @model
      Carrie.CKEDITOR.clearWhoHas("ckeditor-new")
      @cked = "ckeditor-new"
      @model = new Carrie.Models.Question
        exercise: @options.exercise
    else
      @cked = "ckeditor-#{@model.get('id')}"
      @editing = true

    Carrie.CKEDITOR.clearWhoHas("#{@cked}-tip")
    @modelBinder = new Backbone.ModelBinder()

  beforeClose: ->
    $(@el).find("\##{@cked}").ckeditorGet().destroy()

  onRender: ->
    @modelBinder.bind(this.model, this.el)
    cked = "\##{@cked}"
    setTimeout ( ->
      $(cked).ckeditor({language: 'pt-br'})
    ), 100

  cancel: (ev) ->
    ev.preventDefault()
    $(@el).find("\##{@cked}").ckeditorGet().destroy()

    if @editing
      @modelBinder.unbind()
      @model.fetch(async:false)
      @options.view.render()
    else
      $('#new_question').html('')

  create: (ev) ->
    ev.preventDefault()

    Carrie.Utils.Alert.clear(@el)

    @model.set('content', CKEDITOR.instances[@cked].getData())

    @model.save @model.attributes,
      wait: true
      success: (model, response) =>
        console.log(model)
        $(@el).find("\##{@cked}").ckeditorGet().destroy()

        $(@el).find('input.btn-primary').button('reset')
        Carrie.Utils.Alert.success('Questão salva com sucesso!', 3000)

        if @editing
          @options.view.render()
        else
          view = new Carrie.Views.Question({model: @model})
          $('#new_question').after view.render().el
          $('#new_question').html('')

      error: (model, response) =>
        result = $.parseJSON(response.responseText)
        console.log response
        msg = Carrie.Helpers.Notifications.error('Existe erros no seu formulário')
        $(@el).find('form').before(msg)
        Carrie.Utils.Alert.showFormErrors(result.errors, @el)

        $(@el).find('input.btn-primary').button 'reset'
