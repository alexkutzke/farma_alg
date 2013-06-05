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
    'click .answer_btn': 'verify_answer'

  verify_answer: (ev) ->
    ev.preventDefault()
    keyboard = new Carrie.Views.VirtualKeyBoard
      currentResp: @view.resp()
      callback: (val) =>
        @sendAnswer(val)
        
    $(keyboard.render().el).modal('show')

  sendAnswer: (resp) ->
    bootbox.modal("Compilando e executando ...",{backdrop:'static',keyboard:false})

    answer = new Carrie.Models.Answer
      user_id: Carrie.currentUser.get('id')
      question: @model
      response: resp
      for_test: false
      team_id: @options.team_id

    answer.save answer.attributes,
      wait: true
      success: (model, response) =>     
        @view = new Carrie.Views.Answer model: Carrie.Models.AnswerShow.findOrCreate(model.attributes)
        $(@el).find('.answer-group').html @view.render().el
        prettyPrint()
        bootbox.hideAll()

      error: (model, resp) ->
        alert resp.responseText

  onRender: ->
    $(@el).find('.answer-group').html @view.render().el
    #MathJax.Hub.Queue(["Typeset",MathJax.Hub, @el])
