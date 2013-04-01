class Carrie.Views.CreateOrSaveTip extends Backbone.Marionette.ItemView
  template: 'tips/form'

  events:
    'submit form': 'create'
    'click .btn-cancel': 'cancel'

  initialize: ->
    if not @model
      @model = new Carrie.Models.Tip
        question: @options.question
      @cked = "ckeditor-#{@model.get('question').get('id')}-tip-new"
    else
      @cked = "ckeditor-#{@model.get('question').get('id')}-tip-#{@model.get('id')}"
      @editing = true

    Carrie.CKEDITOR.clearWhoHas(@cked)
    @modelBinder = new Backbone.ModelBinder()

    $('.new-tip-link').hide()
    $('.edit-tip-link').hide()

  beforeClose: ->
    $(@el).find("\##{@cked}").ckeditorGet().destroy()

  cancel: (ev) ->
    ev.preventDefault()
    $(@el).find("\##{@cked}").ckeditorGet().destroy()

    if @editing
      @modelBinder.unbind()
      @model.fetch(async:false)
      @options.view.render()
    else
      $(@el).parent().html('')

    $('.new-tip-link').show()
    $('.edit-tip-link').show()

  create: (ev) ->
    ev.preventDefault()
    Carrie.Helpers.Notifications.Form.clear(@el)
    Carrie.Helpers.Notifications.Form.loadSubmit(@el)

    @model.set('content', CKEDITOR.instances[@cked].getData())

    @model.save @model.attributes,
      wait: true
      success: (model, response) =>
        $(@el).find("\##{@cked}").ckeditorGet().destroy()

        Carrie.Helpers.Notifications.Form.resetSubmit(@el)
        Carrie.Helpers.Notifications.Top.success 'Dica salva com sucesso!', 4000

        if @editing
          @model.get('question').get('tips').sort()
        else
          @options.collection.sort()
          $(@el).parent().html('')

        $('.new-tip-link').show()
        $('.edit-tip-link').show()


      error: (model, response, options) =>
        result = $.parseJSON(response.responseText)

        Carrie.Helpers.Notifications.Form.before 'Existe erros no seu formulário', @l
        Carrie.Helpers.Notifications.Form.showErrors(result.errors, @el)
        Carrie.Helpers.Notifications.Form.resetSubmit(@el)

  onRender: ->
    @modelBinder.bind(@model, @el)
    config =
      language: 'pt-br'
      toolbar:[
          { name: 'basicstyles', items : [ 'Bold','Italic' ] },
          { name: 'paragraph', items : [ 'NumberedList','BulletedList' ] },
          { name: 'tools', items : [ 'Maximize','-','About' ] },
          { name: 'insert', items : [ 'Image'] },
          { name: 'colors', items : [ 'TextColor','BGColor' ] }
        ]

    Carrie.CKEDITOR.show "\##{@cked}"
