class Carrie.Views.Question extends Backbone.Marionette.CompositeView
  template: 'questions/question'
  tagName: 'article'
  itemView: Carrie.Views.TestCase
  className: 'question'


  initialize: ->
    @collection = @model.get('test_cases')
    console.log(@collection)

  events:
    'click .destroy-question-link' : 'destroy'
    'click .edit-question-link' : 'edit'
    'click .new-test_case-link': 'addTestCase'
    'click .show-test_cases-link': 'showTestCases'
    'click .answer': 'verify_answer'

  onRender: ->
    @el.id = @model.get('id')
    @view = new Carrie.Views.Answer().render()
    $(@el).find('.answer-group').html @view.render().el
    $(@el).find('span i').tooltip()
    #MathJax.Hub.Queue(["Typeset",MathJax.Hub, @el])

  appendHtml: (collectionView, itemView, index) ->
    $(@el).find('.test_cases section').append(itemView.el) if itemView.model.get('id')

  addTestCase: (ev) ->
    ev.preventDefault()
    form = new Carrie.Views.CreateOrSaveTestCase(question: @model, collection: @collection)
    $(@el).find('.test_cases .new-test_case').html form.render().el

  showTestCases: (ev) ->
    ev.preventDefault()
    $(@el).find('.test_cases').toggle()

  verify_answer: (ev) ->
    ev.preventDefault()
    keyboard = new Carrie.Views.VirtualKeyBoard
      currentResp: @view.resp()
      variables: @model.get('exp_variables')
      many_answers: @model.get('many_answers')
      eql_sinal: @model.get('eql_sinal')
      callback: (val) =>
        @sendAnswer(val)

    $(keyboard.render().el).modal('show')

  sendAnswer: (resp) ->
    bootbox.modal("Compilando e executando ...",{backdrop:'static',keyboard:false})
    answer = new Carrie.Models.Answer
      question: @model
      user_id: Carrie.currentUser.get('id')
      response: resp
      for_test: true

    answer.save answer.attributes,
      wait: true
      success: (model, response) =>     
        @view = new Carrie.Views.Answer model: Carrie.Models.AnswerShow.findOrCreate(model.attributes)
        $(@el).find('.answer-group').html @view.render().el
        prettyPrint()
        bootbox.hideAll()

      error: (model, resp) ->
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
            Carrie.Helpers.Notifications.Top.success 'Questão removido com sucesso!', 4000
