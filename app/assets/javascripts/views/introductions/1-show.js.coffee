class Carrie.Views.IntroductionShow extends Backbone.Marionette.ItemView
  template: 'introductions/show'
  tagName: 'article'

  events:
    'click #edit_intro' : 'edit'
    'click #destroy_intro' : 'destroy'
    'click #show_intro' : 'show'

  show: (ev) ->
    ev.preventDefault()
    id = $(ev.target).data('id')
    $('#'+id).find('.intro-content').toggle('blind', {}, 500)

  edit: (ev) ->
    ev.preventDefault()
    id = $(ev.target).data('id')
    Backbone.history.navigate('/los/'+@model.get('lo').get('id')+'/introductions/edit/'+id, true)

  destroy: (ev) ->
    ev.preventDefault()
    intro = Carrie.Models.Introduction.findOrCreate
      id: $(ev.target).data('id')

    msg = "Você tem certeza que deseja remover esta introdução?"

    bootbox.confirm msg, (confirmed) ->
      if confirmed
        intro.destroy
          wait: true
          success: (model, response) ->
            $('#'+model.get('id')).fadeOut(800, 'linear')

            Carrie.Utils.Alert.success('Introducação removida com sucesso!', 2500)

  onRender: ->
    @el.id = @model.get('id')
