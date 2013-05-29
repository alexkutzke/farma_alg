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

    Carrie.CKEDITOR.clearWhoHas("#{@cked}-test_case")
    @modelBinder = new Backbone.ModelBinder()

  beforeClose: ->
    $(@el).find("\##{@cked}").ckeditorGet().destroy()

  onRender: ->
    @modelBinder.bind(this.model, this.el)
    Carrie.CKEDITOR.show "\##{@cked}"

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

    Carrie.Helpers.Notifications.Form.clear(@el)
    Carrie.Helpers.Notifications.Form.loadSubmit(@el)

    @model.set('content', CKEDITOR.instances[@cked].getData())

    @model.save @model.attributes,
      wait: true
      success: (model, response, options) =>
        $(@el).find("\##{@cked}").ckeditorGet().destroy()

        Carrie.Helpers.Notifications.Form.resetSubmit(@el)
        Carrie.Helpers.Notifications.Top.success 'Questão salva com sucesso!', 4000

        if @editing
          @options.view.render()
        else
          view = new Carrie.Views.Question({model: @model})
          $('#new_question').after view.render().el
          $('#new_question').html('')

      error: (model, response, options) =>
        result = $.parseJSON(response.responseText)

        Carrie.Helpers.Notifications.Form.before 'Existe erros no seu formulário', @l
        Carrie.Helpers.Notifications.Form.showErrors(result.errors, @el)
        Carrie.Helpers.Notifications.Form.resetSubmit(@el)
