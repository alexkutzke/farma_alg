class Carrie.Views.Question extends Backbone.Marionette.CompositeView
  template: 'questions/question'
  tagName: 'article'
  itemView: Carrie.Views.TestCase
  className: 'question'
  openTestCase: true
  openDetails: true


  initialize: ->
    @collection = @model.get('test_cases')
    
  events:
    'click .destroy-question-link' : 'destroy'
    'click .edit-question-link' : 'edit'
    #'click .new-test_case-link22': 'addTestCase'
    'click .show-test_cases-link': 'showTestCases'
    'click .details-question-link': 'details'
    'click .answer_btn': 'verify_answer'


  onRender: ->
    @el.id = @model.get('id')
    @view = new Carrie.Views.Answer().render()
    $(@el).find('.answer-group').html @view.render().el
    $(@el).find('span i').tooltip()
    #console.log $(@el).find('.new-test_case-link22')
    x = this
    $(@el).find('.new-test_case-link22').on('click', (ev) -> 
      ev.preventDefault()
      x.addTestCase(ev)
    )

  appendHtml: (collectionView, itemView, index) ->
    $(@el).find('.test_cases').append(itemView.el) if itemView.model.get('id')

  addTestCase: (ev) ->
    #ev.preventDefault()
    form = new Carrie.Views.CreateOrSaveTestCase(question: @model, collection: @collection, x: @)
    $('#new_test_case_'+@model.get('id')).html form.render().el

  showTestCases: (ev) ->
    ev.preventDefault()

    if @openTestCase
      $(@el).find('#'+"test_cases_modal_"+@model.get('id')).slideDown()
      @openTestCase = false
    else
      $(@el).find('#'+"test_cases_modal_"+@model.get('id')).slideUp()
      @openTestCase = true

  verify_answer: (ev) ->
    ev.preventDefault()
    keyboard = new Carrie.Views.VirtualKeyBoard
      languages: @model.get('languages')
      currentResp: @view.resp()
      callback: (val,lang) =>
        @sendAnswer(val,lang)

    $(keyboard.render().el).modal('show').css({'margin-top':  -> 
      -($(this).height() / 2)
    });
       
  sendAnswer: (resp,lang) ->
    bootbox.modal("Compilando e executando ...",{backdrop:'static',keyboard:false})
    answer = new Carrie.Models.Answer
      question: @model
      user_id: Carrie.currentUser.get('id')
      response: resp
      lang: lang
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

  details: (ev) ->
    ev.preventDefault()

    if @openDetails
      $(@el).find("#details_question_"+@model.get('id')).slideDown()
      @openDetails = false
    else
      $(@el).find("#details_question_"+@model.get('id')).slideUp()
      @openDetails = true

  edit: (ev) ->
    ev.preventDefault()
    form = new Carrie.Views.CreateOrSaveQuestion(model: @model, view: @)
    x = @
    $(@el).slideUp('slow',->
      $(x.el).html form.render().el
      $(x.el).slideDown()
    )
    

  destroy: (ev) ->
    ev.preventDefault()
    msg = "Você tem certeza que deseja remover esta questão?"

    bootbox.confirm msg, (confirmed) =>
      if confirmed
        Carrie.CKEDITOR.clearWhoHas(@model.get('id'))
        @model.destroy
          success: (model, response) =>
            #console.log @
            @remove()
            Carrie.Helpers.Notifications.Top.success 'Questão removido com sucesso!', 4000
