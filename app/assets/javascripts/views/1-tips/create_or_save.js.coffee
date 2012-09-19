class Carrie.Views.CreateOrSaveTip extends Backbone.Marionette.ItemView
  template: 'tips/form'

  events:
    'submit form': 'create'
    'click .btn-cancel': 'cancel'

  initialize: ->
    if not @model
      @model = new Carrie.Models.Tip
        question: @options.question
    else
      @editing = true

    @modelBinder = new Backbone.ModelBinder()

  cancel: (ev) ->
    ev.preventDefault()
    if @editing
      @modelBinder.unbind()
      @model.fetch(async:false)
      @options.view.render()
    else
      $(@el).parent().html('')

  create: (ev) ->
    ev.preventDefault()

    Carrie.Utils.Alert.clear(@el)

    @model.save @model.attributes,
      wait: true
      success: (model, response) =>
        $(@el).find('input.btn-primary').button('reset')
        Carrie.Utils.Alert.success('Diaca salva com sucesso!', 3000)

        if @editing
          @model.get('question').get('tips').sort()
        else
          @options.collection.sort()
          $(@el).parent().html('')

      error: (model, response) =>
        result = $.parseJSON(response.responseText)

        msg = Carrie.Helpers.Notifications.error('Existe erros no seu formulário')
        $(@el).find('form').before(msg)
        Carrie.Utils.Alert.showFormErrors(result.errors, @el)

        $(@el).find('input.btn-primary').button 'reset'

  onRender: ->
    @modelBinder.bind(@model, @el)
