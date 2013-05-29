class Carrie.Views.TestCase extends Backbone.Marionette.ItemView
  template: 'test_cases/test_case'
  tagName: 'div'
  className: 'well'

  events:
    'click .destroy-test_case-link' : 'destroy'
    'click .edit-test_case-link' : 'edit'

  edit: (ev) ->
    ev.preventDefault()
    form = new Carrie.Views.CreateOrSaveTestCase(model: @model, view: @)
    $(@el).html form.render().el

  destroy: (ev) ->
    ev.preventDefault()

    msg = "Você tem certeza que deseja remover este caso de teste?"

    bootbox.confirm msg, (confirmed) =>
      if confirmed
        @model.destroy
          success: (model, response) =>
            @remove()
            Carrie.Helpers.Notifications.Top.success 'Caso de teste removido com sucesso!', 4000

  onRender: ->
    @el.id = @model.get('id')
 