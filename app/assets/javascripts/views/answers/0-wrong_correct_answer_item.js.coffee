class Carrie.Views.WrongCorrectAnswerItem extends Backbone.Marionette.ItemView
  tagName: 'tr'
  template: 'answers/wrong_correct_answer_item'
  className: 'answers-link'

  initialize: ->
    @answer = Carrie.Models.Retroaction.Answer.findOrCreate(@model.get('id'))
    @answer = new Carrie.Models.Retroaction.Answer(id: @model.get('id')) if not @answer

  events:
    'click' : 'retro'

  retro: (ev) ->
    @clearModel()
    @answer.fetch
      async: false
      success: (model, response, options) =>
        view = new Carrie.Views.Retroaction.Answer(model: @answer).render().el
        $(view).modal('show')
      error: (model, response, options) ->
        Carrie.Helpers.Notifications.Top.success 'Não foi possível retroagir a essa resposta!', 4000

  clearModel: ->
    @answer.clear()
    @answer.set('id', @model.get('id'))
