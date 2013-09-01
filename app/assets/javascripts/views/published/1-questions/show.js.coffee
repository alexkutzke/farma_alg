class Carrie.Published.Views.Question extends Backbone.Marionette.ItemView
  template: 'published/questions/show'
  tagName: 'article'
  className: 'question'

  initialize: ->
    if @model.get('last_answer')
      model = Carrie.Models.AnswerShow.findOrCreate(@model.get('last_answer'))

      unless model
        model = new Carrie.Models.AnswerShow(@model.get('last_answer'))

      model.set('last_answers',@model.get('last_answers'))
      @view = new Carrie.Views.Answer model: model
    else
      @view = new Carrie.Views.Answer()

  events:
    'click .answer_btn': 'verify_answer'
    'click .reload-answer-link': 'reload'
    'click .last-answers-link': 'showLastAnswers'

  showLastAnswers: (ev) ->
    ev.preventDefault()
    console.log "#accordion_code_"+@model.get('id')
    $(@el).find("#accordion_code_"+@model.get('id')).toggle()

  reload: (ev) ->
    ev.preventDefault()
    keyboard = new Carrie.Views.VirtualKeyBoard
      currentResp: @model.get('last_answers')[parseInt($(ev.target).data('id'))].response
      lang: @model.get('last_answers')[parseInt($(ev.target).data('id'))].lang
      languages: @model.get('languages')
      callback: (val,lang) =>
        @sendAnswer(val,lang)
        
     $(keyboard.render().el).modal({show: true}).css({'margin-top':  -> 
      -($(this).height() / 2)
    });

  verify_answer: (ev) ->
    ev.preventDefault()
    keyboard = new Carrie.Views.VirtualKeyBoard
      currentResp: @view.resp()
      lang: @view.lang()
      languages: @model.get('languages')
      callback: (val,lang) =>
        @sendAnswer(val,lang)
        
     $(keyboard.render().el).modal({show: true}).css({'margin-top':  -> 
      -($(this).height() / 2)
    });

  sendAnswer: (resp,lang) ->
    bootbox.modal("Compilando e executando ...",{backdrop:'static',keyboard:false})

    console.log "123123213---------------------------------"

    answer = new Carrie.Models.Answer
      user_id: Carrie.currentUser.get('id')
      lang: lang
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
    


