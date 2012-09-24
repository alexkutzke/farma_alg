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

    Carrie.Utils.Alert.clear(@el)

    @model.set('content', CKEDITOR.instances[@cked].getData())

    @model.save @model.attributes,
      wait: true
      success: (model, response) =>
        $(@el).find("\##{@cked}").ckeditorGet().destroy()
        $(@el).find('input.btn-primary').button('reset')

        Carrie.Utils.Alert.success('Diaca salva com sucesso!', 3000)

        if @editing
          @model.get('question').get('tips').sort()
        else
          @options.collection.sort()
          $(@el).parent().html('')

        $('.new-tip-link').show()
        $('.edit-tip-link').show()

      error: (model, response) =>
        result = $.parseJSON(response.responseText)

        msg = Carrie.Helpers.Notifications.error('Existe erros no seu formulário')
        $(@el).find('form').before(msg)
        Carrie.Utils.Alert.showFormErrors(result.errors, @el)

        $(@el).find('input.btn-primary').button 'reset'

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

    cked = "\##{@cked}"
    setTimeout ( ->
      $(cked).ckeditor(config)
    ), 100


