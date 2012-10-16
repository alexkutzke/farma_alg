class Carrie.Views.TeamShow extends Backbone.Marionette.ItemView
  template: 'teams/each_created'
  tagName: 'article'

  events:
    'click #edit_team' : 'edit'
    'click #destroy_team' : 'destroy'

  edit: (ev) ->
    ev.preventDefault()
    id = @model.get('id')
    Backbone.history.navigate("/teams/edit/#{@model.get('id')}", true)

  destroy: (ev) ->
    ev.preventDefault()
    msg = "Você tem certeza que deseja remover esta turma?"

    bootbox.confirm msg, (confirmed) =>
      if confirmed
        team = Carrie.Models.Team.findOrCreate id: @model.get('id')
        team.destroy
          success: (model, response) =>
            $(@el).fadeOut(800, 'linear')

            Carrie.Utils.Alert.success('Turma removida com sucesso!', 2500)

  onRender: ->
    @el.id = @model.get('id')
