class Carrie.Views.VirtualKeyBoard extends Backbone.Marionette.ItemView
  template: 'virtual_keyboard/show'
  className: 'virtual-keyboard modal'

  events:
    'click a' : 'setInput'

  initialize: ->
    @variables = @options.variables || []
    @callback = @options.callback || ->
    @errorClass = 'error'
    $(@el).on 'hide', =>
      @remove()
    _.bindAll(@, 'keyUp')
    $(document).bind('keyup', @keyUp)


  onRender: ->
    @input = $($(@el).find('.keyboard-input').first())
    @display = $($(@el).find('div.display').first())
    @addVariables()
    @inputFocus()
    @input.attr('value', @options.currentResp)
    @updateDisplay()
    MathJax.Hub.Queue(["Typeset",MathJax.Hub, @el])
    @el

  keyUp: (ev) ->
    if (ev.which == 13 )
      ev.preventDefault()
      @send()

    @updateDisplay()

  setInput: (ev) ->
    ev.preventDefault()
    value = $(ev.target).data('value').toString()
    @input.focus()

    switch value
      when 'sqrt'
        @input.insertAtCursor("sqrt()")
        cursor = @input.getCursorPosition() - 1
        @input.setSelection(cursor, cursor)
      when 'clean'
        @input.val('')
      when '^'
        @input.insertAtCursor("^()")
        cursor = @input.getCursorPosition() - 1
        @input.setSelection(cursor, cursor)
      when 'backspace'
        formula = @input.val().substring(0, @input.getCursorPosition()-1) + @input.val().substring(@input.getCursorPosition(), @input.val().length)

        cursor = @input.getCursorPosition()-1
        @input.val(formula)
        @input.setSelection(cursor, cursor)
      when 'send'
        @send()
      else
        @input.insertAtCursor(value)

    @updateDisplay()

  send: ->
    val = @input.val()
    if (@validateExpression())
       @callback val, @display.html()
       $(@el).modal('hide')
    else
       @input.next().show()

  updateDisplay: ->
    exp = @input.val()
    if @validateExpression()
      @input.removeClass(@errorClass)
      @input.next().hide()
    else
      @input.addClass(@errorClass)

    @display.html('$'+exp+'$')
    MathJax.Hub.Queue(["Typeset",MathJax.Hub, @display[0]])

  inputFocus: ->
    setTimeout ( =>
      @input.focus()
    ), 100

  addVariables: ->
    if @options.many_answers && @variables.indexOf(';') == -1
      @variables.push ';'

    obj = $(@el).find('.variables')
    $.each @variables, (index, el) ->
      btn = "<a href='#display' class='btn' data-value='#{el}' title='variável #{el}'>$#{el}$</a>"
      obj.append(btn)
      if (index + 1) % 5 == 0
        obj.append('<div></div>')

  validateExpression: ->
    try
      vars = {}
      exp = @input.val().trim()

      if exp.slice(-1) == ';'
        return false

      exp = @manyAnswers(exp)

      $.each @variables, (index, el) ->
        vars[el] = Math.random()

      rst = Parser.evaluate(exp, vars)

      if (isNaN(rst) || (exp.indexOf('sqrt()') != -1))
         return false

      return true
    catch e
      return false

  manyAnswers: (exp) ->
    exps = exp.split(';')
    _exp = exps.pop()
    $.each exps, (index, el) ->
      _exp = "(#{_exp}) + (#{el})"
    return _exp


