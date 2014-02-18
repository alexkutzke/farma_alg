# Answer for construct a exercise
class Carrie.Views.Answer extends Backbone.Marionette.ItemView
  template: null
  tagName: 'div'
  events:
    'click .details-answer-link': 'details'

  initialize: ->
    if @model
      if not @model.get('correct')
        @model.set('classname', 'wrong')
        @model.set('title', 'Incorreto')
        @model.set('ok','')
      else
        @model.set('classname', 'right')
        @model.set('title', 'Correto')
        @model.set('ok','ok')

      @template = 'answers/answer'

      #console.log @model.attributes
    else
      @template = 'answers/answer_empty'

  details: (ev) ->
    ev.preventDefault()
    $(@el).find("#details_answer_"+$(ev.target).data('id')).toggle()

  resp: ->
    if @model
      return @model.get('response')
    else
      return ""

  lang: ->
    if @model
      return @model.get('lang')
    else
      return ""

  onRender: ->
    $(@el).find('span.label').tooltip()
    #console.log @model
    if @model
      las = @model.get('last_answers')
      #console.log(las)
      las = $.map(las, (k, v) ->
        [k]
      )
      i=0
      while i<las.length
        @diffUsingJS(las[i].id,las[i].response,las[i].previous)
        i++;

  diffUsingJS: (answer_id,resp1,resp2) ->

    # get the baseText and newText values from the two textboxes, and split them into lines
    base = difflib.stringAsLines(resp1)#$("baseText").value);
    newtxt = difflib.stringAsLines(resp2)#$("newText").value);

    #create a SequenceMatcher instance that diffs the two sets of lines
    sm = new difflib.SequenceMatcher(base, newtxt);

    # get the opcodes from the SequenceMatcher instance
    # opcodes is a list of 3-tuples describing what changes should be made to the base text
    # in order to yield the new text
    opcodes = sm.get_opcodes();
    diffoutputdiv = $(@el).find("#"+answer_id);
    while diffoutputdiv.firstChild
      diffoutputdiv.removeChild(diffoutputdiv.firstChild);

    #console.log opcodes

    $(diffoutputdiv).append(diffview.buildView({baseTextLines: base, newTextLines: newtxt, opcodes: opcodes, baseTextName: "Resposta", newTextName: "Resposta anterior", contextSize: 0, viewType: 0 }))
