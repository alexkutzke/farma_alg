class Carrie.Views.Retroaction.Question extends Backbone.Marionette.ItemView
  template: 'retroaction/question'
  className: 'question'

  events:
    'click .answer_btn': 'verify_answer'

  initialize: ->
    console.log @model
    if @model.get('last_answer')
      model = Carrie.Models.AnswerShow.findOrCreate(@model.get('last_answer'))
      unless model
        model = new Carrie.Models.AnswerShow(@model.get('last_answer'))
      @view = new Carrie.Views.Answer model: model
    else
      @view = new Carrie.Views.Answer()

  onRender: ->
    $(@el).find('answer-group').html @view.render().el
    $('.accordion-body').on 'hidden', (event) =>
      event.stopPropagation()
    #MathJax.Hub.Queue(["Typeset",MathJax.Hub, @el])

  verify_answer: (ev) ->
    ev.preventDefault()
    keyboard = new Carrie.Views.VirtualKeyBoard
      currentResp: @view.resp()
      callback: (val) =>
        @sendAnswer(val)
        
    $(keyboard.render().el).modal('show')

  sendAnswer: (resp) ->
    answer = new Carrie.Models.RetroactionAnswer
      question_id: @model.get('_id')
      answer_id: @model.get('exercise').get('answer').get('id')
      user_id: Carrie.currentUser.get('id')
      response: resp

    answer.save answer.attributes,
      wait: true
      success: (model, response, options) =>
        answerShow = Carrie.Models.AnswerShow.findOrCreate(model.get('id'))
        if answerShow
          answerShow.set model.attributes
        else
          answerShow = new Carrie.Models.AnswerShow(model.attributes)

        @view.close()
        @view = new Carrie.Views.Answer model: answerShow
        $(@el).find('.answer-group').html @view.render().el
        $('.accordion-body').on 'hidden', (event) =>
          event.stopPropagation()

      error: (model, resp, options) ->
        alert resp.responseText
