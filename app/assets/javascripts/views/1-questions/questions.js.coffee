class Carrie.Views.Question extends Backbone.Marionette.ItemView
  template: 'questions/question'
  tagName: 'article'

  events:
    'click #destroy-question-link' : 'destroy'
    'click #edit-question-link' : 'edit'
    'click .btn-verify': 'verify_answer'

  onRender: ->
    @el.id = @model.get('id')
    $(@el).find('span i').tooltip()

  verify_answer: (ev) ->
    ev.preventDefault()
    alert ('Em desenvolvimento')

  edit: (ev) ->
    ev.preventDefault()
    q = Carrie.Models.Question.findOrCreate id: @el.id

    form = new Carrie.Views.CreateOrSaveQuestion(model: q)
    $(@el).html form.render().el

  destroy: (ev) ->
    ev.preventDefault()
    q = Carrie.Models.Question.findOrCreate id: @el.id

    msg = "Você tem certeza que deseja remover esta questão?"

    bootbox.confirm msg, (confirmed) ->
      if confirmed
        q.destroy
          wait: true
          success: (model, response) ->
            $(@el).fadeOut(800, 'linear')

            Carrie.Utils.Alert.success('Questão removida com sucesso!', 2500)

