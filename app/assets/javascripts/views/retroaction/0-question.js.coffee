class Carrie.Views.Retroaction.Question extends Backbone.Marionette.ItemView
  template: 'retroaction/question'
  className: 'question'

  events:
    'click .answer': 'verify_answer'

  initialize: ->
    if @model.get('last_answer')
      model = Carrie.Models.AnswerShow.findOrCreate(@model.get('last_answer'))
      unless model
        model = new Carrie.Models.AnswerShow(@model.get('last_answer'))
      @view = new Carrie.Views.Answer model: model
    else
      @view = new Carrie.Views.Answer()

  onRender: ->
    $(@el).find('.answer-group').html @view.render().el
    MathJax.Hub.Queue(["Typeset",MathJax.Hub, @el])

  verify_answer: (ev) ->
    ev.preventDefault()
    keyboard = new Carrie.Views.VirtualKeyBoard(
      currentResp: @view.resp()
      variables: @model.get('exp_variables')
      many_answers: @model.get('many_answers')
      callback: (val) ->
        alert val
    ).render().el
    $(keyboard).modal('show')
