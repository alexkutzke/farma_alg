class Carrie.Views.Question extends Backbone.Marionette.CompositeView
  template: 'questions/question'
  tagName: 'article'
  itemView: Carrie.Views.Tip
  className: 'question'

  initialize: ->
    @collection = @model.get('tips')

  events:
    'click .destroy-question-link' : 'destroy'
    'click .edit-question-link' : 'edit'
    "click .new-tip-link": 'addTip'
    'click .show-tips-link': 'showTips'
    'click .answer': 'verify_answer'

  onRender: ->
    @el.id = @model.get('id')
    $(@el).find('.answer-group').html new Carrie.Views.Answer().render().el

    $(@el).find('span i').tooltip()
    MathJax.Hub.Queue(["Typeset",MathJax.Hub, @el])

  appendHtml: (collectionView, itemView, index) ->
    $(@el).find('.tips section').append(itemView.el) if itemView.model.get('id')

  addTip: (ev) ->
    ev.preventDefault()
    form = new Carrie.Views.CreateOrSaveTip(question: @model, collection: @collection)
    $(@el).find('.tips .new-tip').html form.render().el

  showTips: (ev) ->
    ev.preventDefault()
    $(@el).find('.tips').toggle()

  verify_answer: (ev) ->
    ev.preventDefault()
    resp = prompt('Digite sua resposta')

    answer = new Carrie.Models.Answer
      question: @model
      user_id: Carrie.currentUser.get('id')
      response: resp
      for_test: true

    answer.save answer.attributes,
      wait: true
      success: (model, response) =>
        view = new Carrie.Views.Answer model: new Carrie.Models.AnswerShow(model.attributes)
        $(@el).find('.answer-group').html view.render().el

      error: (model, resp) ->
        console.log(model)
        alert resp.responseText

  edit: (ev) ->
    ev.preventDefault()
    form = new Carrie.Views.CreateOrSaveQuestion(model: @model, view: @)
    $(@el).html form.render().el

  destroy: (ev) ->
    ev.preventDefault()
    msg = "Você tem certeza que deseja remover esta questão?"

    bootbox.confirm msg, (confirmed) =>
      if confirmed
        Carrie.CKEDITOR.clearWhoHas(@model.get('id'))
        @model.destroy
          success: (model, response) =>
            @remove()
            Carrie.Utils.Alert.success('Questão removida com sucesso!', 2500)
