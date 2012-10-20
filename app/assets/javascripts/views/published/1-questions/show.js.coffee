class Carrie.Published.Views.Question extends Backbone.Marionette.ItemView
  template: 'published/questions/show'
  tagName: 'article'
  className: 'question'

  initialize: ->
    if @model.get('last_answer')
      model = Carrie.Models.AnswerShow.findOrCreate(@model.get('last_answer'))
      unless model
        model = new Carrie.Models.AnswerShow(@model.get('last_answer'))
      @view = new Carrie.Views.Answer model: model
    else
      @view = new Carrie.Views.Answer()

  events:
    'click .answer': 'verify_answer'

  verify_answer: (ev) ->
    ev.preventDefault()
    keyboard = new Carrie.Views.VirtualKeyBoard
      currentResp: @view.resp()
      variables: @model.get('exp_variables')
      many_answers: @model.get('many_answers')
      callback: (val) =>
        @sendAnswer(val)

    $(keyboard.render().el).modal('show')

  sendAnswer: (resp) ->
    answer = new Carrie.Models.Answer
      question: @model
      user_id: Carrie.currentUser.get('id')
      response: resp

    answer.save answer.attributes,
      wait: true
      success: (model, response) =>
        @view = new Carrie.Views.Answer model: Carrie.Models.AnswerShow.findOrCreate(model.attributes)
        $(@el).find('.answer-group').html @view.render().el

        last_answer =
          tip: model.get('tip')
          correct: model.get('correct')
          response: model.get('response')
          try_number: model.get('try_number')
        @model.set('last_answer', last_answer)

      error: (model, resp) ->
        console.log(model)
        alert resp.responseText


  onRender: ->
    $(@el).find('.answer-group').html @view.render().el
    MathJax.Hub.Queue(["Typeset",MathJax.Hub, @el])
