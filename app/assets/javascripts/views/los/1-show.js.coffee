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
    'click .view-lo-btn' : 'viewLo'

  viewLo: (ev) ->
    ev.preventDefault()
    alert ('Em desenvolvimento')

  viewIntroductions: (ev) ->
    ev.preventDefault()
    url = '/los/' + @model.get('id') + '/introductions'
    Backbone.history.navigate(url, true)

  viewExercises: (ev) ->
    ev.preventDefault()
    url = '/los/' + @model.get('id') + '/exercises'
    Backbone.history.navigate(url, true)

  edit_lo: (ev) ->
    ev.preventDefault()
    Backbone.history.navigate('/los/edit/'+@model.get('id'), true)

  destroy_lo: (ev) ->
    ev.preventDefault()

    msg = "Você tem certeza que deseja remover este Objeto de Aprendizagem?"

    bootbox.confirm msg, (confirmed) =>
      if confirmed
        @model.destroy
          success: (model, response) ->
            $(@el).fadeOut(800, 'linear')
            @remove
            Carrie.Utils.Alert.success('OA removido com sucesso!', 3000)
