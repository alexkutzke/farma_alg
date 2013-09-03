class Carrie.Views.CreateOrSaveTestCase extends Backbone.Marionette.ItemView
  template: 'test_cases/form'

  events:
    'submit form': 'create'
    'click .btn-cancel': 'cancel'

  initialize: ->
    if not @model
      @model = new Carrie.Models.TestCase
        question: @options.question
      @cked = "ckeditor-#{@model.get('question').get('id')}-test_case-new"
      @cked2 = "ckeditor-#{@model.get('question').get('id')}-test_case-new-tip"
    else
      @cked = "ckeditor-#{@model.get('question').get('id')}-test_case-#{@model.get('id')}"
      @cked2 = "ckeditor-#{@model.get('question').get('id')}-test_case-tip-#{@model.get('id')}"
      @editing = true

    Carrie.CKEDITOR.clearWhoHas(@cked)
    Carrie.CKEDITOR.clearWhoHas(@cked2)
    @modelBinder = new Backbone.ModelBinder()

    $('.new-test_case-link').hide()
    $('.edit-test_case-link').hide()

  beforeClose: ->
    $(@el).find("\##{@cked}").ckeditorGet().destroy()
    $(@el).find("\##{@cked2}").ckeditorGet().destroy()

  cancel: (ev) ->
    ev.preventDefault()
    $(@el).find("\##{@cked}").ckeditorGet().destroy()
    $(@el).find("\##{@cked2}").ckeditorGet().destroy()

    if @editing
      @modelBinder.unbind()
      @model.fetch(async:false)
      @options.view.render()
    else
      $(@el).parent().html('')

    $('.new-test_case-link').show()
    $('.edit-test_case-link').show()

  create: (ev) ->
    ev.preventDefault()
    Carrie.Helpers.Notifications.Form.clear(@el)
    Carrie.Helpers.Notifications.Form.loadSubmit(@el)

    @model.set('content', CKEDITOR.instances[@cked].getData())
    @model.set('tip', CKEDITOR.instances[@cked2].getData())

    @model.save @model.attributes,
      wait: true
      success: (model, response) =>
        $(@el).find("\##{@cked}").ckeditorGet().destroy()
        $(@el).find("\##{@cked2}").ckeditorGet().destroy()

        Carrie.Helpers.Notifications.Form.resetSubmit(@el)
        Carrie.Helpers.Notifications.Top.success 'Caso de Teste salvo com sucesso!', 4000

        if @editing
          @options.view.render()
        else
          $(@el).parent().html('')
          @options.x.render()          
          $(@options.x.el).find('#'+"test_cases_modal_"+@options.x.model.get('id')).slideDown()

        $('.new-test_case-link').show()
        $('.edit-test_case-link').show()


      error: (model, response, options) =>
        result = $.parseJSON(response.responseText)

        Carrie.Helpers.Notifications.Form.before 'Existem erros no seu formulário', @l
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
    Carrie.CKEDITOR.show "\##{@cked2}"
    $(@el).find('i.icon-question-sign').tooltip()

