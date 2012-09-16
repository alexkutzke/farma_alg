class Carrie.Views.Lo extends Backbone.Marionette.ItemView
  template: 'los/show'
  tagName: 'article'

  onRender: ->
    @el.id = @model.get('id')
    $(@el).find('span.icon i').tooltip()

  events:
    'click .edit-lo' : 'edit_lo'
    'click .destroy-lo' : 'destroy_lo'
    'click .introductions-btn' : 'viewIntroductions'
    'click .exercises-btn' : 'viewExercises'

  viewIntroductions: (ev) ->
    ev.preventDefault()
    url = '/los/' + $(ev.target).data('id') + '/introductions'
    Backbone.history.navigate(url, true)

  viewExercises: (ev) ->
    ev.preventDefault()
    url = '/los/' + $(ev.target).data('id') + '/exercises'
    Backbone.history.navigate(url, true)

  edit_lo: (ev) ->
    id = $(ev.target).data('id')
    ev.preventDefault()
    Backbone.history.navigate('/los/edit/'+id, true)

  destroy_lo: (ev) ->
    ev.preventDefault()
    lo = Carrie.Models.Lo.findOrCreate
      id: $(ev.target).data('id')

    msg = "Você tem certeza que deseja remover este Objeto de Aprendizagem?"

    bootbox.confirm msg, (confirmed) ->
      if confirmed
        lo.destroy
          wait: true
          success: (model, response) ->
            $('#'+model.get('id')).fadeOut(800, 'linear')

            Carrie.Utils.Alert.success('OA removido com sucesso!', 3000)
