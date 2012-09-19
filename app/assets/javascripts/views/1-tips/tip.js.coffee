class Carrie.Views.Tip extends Backbone.Marionette.ItemView
  template: 'tips/tip'
  tagName: 'div'
  className: 'well'

  events:
    'click .destroy-tip-link' : 'destroy'
    'click .edit-tip-link' : 'edit'

  edit: (ev) ->
    ev.preventDefault()
    form = new Carrie.Views.CreateOrSaveTip(model: @model, view: @)
    $(@el).html form.render().el

  destroy: (ev) ->
    ev.preventDefault()

    msg = "Você tem certeza que deseja remover esta dica?"

    bootbox.confirm msg, (confirmed) =>
      if confirmed
        @model.destroy
          success: (model, response) =>
            @remove()
            Carrie.Utils.Alert.success('Dica removida com sucesso!', 2500)

  onRender: ->
    @el.id = @model.get('id')
