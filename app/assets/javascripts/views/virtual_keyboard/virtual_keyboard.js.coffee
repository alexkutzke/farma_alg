class Carrie.Views.VirtualKeyBoard extends Backbone.Marionette.ItemView
  template: 'virtual_keyboard/show'
  className: 'virtual-keyboard modal'

  events:
    'click a' : 'setInput'
    'keypress .keyboard-input' : 'keyboardInputEnter'
    'keyup .keyboard-input' : 'updateDisplayFromInput'

  initialize: ->
    @variables = @options.variables || []
    @callback = @options.callback || ->
    @errorClass = 'error'
    $(@el).on 'destroy', =>
      @remove()
    _.bindAll(@, 'keyUp')

    # valid keys
    # Default valid keys
    # [0,1,2,3,4,5,6,7,8,9]
    # backspace, + - * / ^ . () sqrt space, ; directonal
    @validKeys = [8, 43,45,42,47,46, 40,41, 115,113,114,116, 32, 0]
    if @options.many_answers
      @validKeys.push(59)
    if @options.eql_sinal
      @validKeys.push(61)

  onRender: ->
    $(@el).bind('keyup', @keyUp)
    $(@el).attr('tabindex', -1)
    @input = $($(@el).find('.keyboard-input').first())
    @display = $($(@el).find('div.display').first())
    @addVariables()
    @input.attr('value', @options.currentResp)
    @updateDisplay()
    @inputFocus()
    MathJax.Hub.Queue(["Typeset",MathJax.Hub, @el])
    @draggable()
    @el

  keyUp: (ev) ->
    # Enter pressed
    if (ev.which == 13 )
      ev.preventDefault()
      @send()

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
      #when '^'
      #  @input.insertAtCursor("^()")
      #  cursor = @input.getCursorPosition() - 1
      #  @input.setSelection(cursor, cursor)
      when 'backspace'
        formula = @input.val().substring(0, @input.getCursorPosition()-1) + @input.val().substring(@input.getCursorPosition(), @input.val().length)

        cursor = @input.getCursorPosition()-1
        @input.val(formula)
        @input.setSelection(cursor, cursor)
      when 'send'
        @send()
      when 'calc' # Function calculate
        @calculator()
      else
        @input.insertAtCursor(value)

    @updateDisplay()

  calculator: ->
    try
      exp = @input.val()
      rsult = Parser.evaluate(exp, {})
      @display.html('$'+rsult+'$')
      @input.val(rsult)
    catch e
      @input.next().show() if @input


  send: ->
    val = @input.val()
    if (@validateExpression())
      @callback val, @display.html()
      $(@el).modal('hide')
    else
       @input.next().show()

  updateDisplay: ->
    expression = @input.val()
    if @validateExpression()
      @input.removeClass(@errorClass)
      @input.next().hide()
    else
      @input.addClass(@errorClass)

    @display.html('$'+expression+'$')
    MathJax.Hub.Queue(["Typeset",MathJax.Hub, @display[0]])

  inputFocus: ->
    self = @
    setTimeout ( ->
      self.input.focus()
    ), 100

  draggable: ->
    setTimeout ( =>
      $(@el).draggable()
    ), 100

  addVariables: ->
    btns = jQuery.deepclone(@variables)
    if @options.many_answers && @variables.indexOf(';') == -1
      btns.push ';'

    if @options.eql_sinal && @variables.indexOf('=') == -1
      btns.push '='

    obj = $(@el).find('.variables')
    $.each btns, (index, el) ->
      btn = "<a href='#display' class='btn' data-value='#{el}' title='variável #{el}'>#{el}</a>"
      obj.append(btn)
      if (index + 1) % 5 == 0
        obj.append('<div></div>')

  validateExpression: ->
    try
      vars = {}
      exp = @input.val().trim()

      if exp.slice(-1) == ';' || exp.slice(-1) == '='
        return false

      exp = @manyAnswers(exp)

      $.each @variables, (index, el) ->
        vars[el] = Math.random()

      rst = Parser.evaluate(exp, vars)

      if (isNaN(rst) || (exp.indexOf('sqrt()') != -1))
         return false

      return true
    catch e
      #console.log e.message
      return false

  # 1 ; a + 2 ; c * 3
  manyAnswers: (exp) ->
    exps = exp.split(';').clean('')
    #exps.clean('')
    _exp = @withEqlSinal(exps.pop())
    $.each exps, (index, el) =>
      _el = @withEqlSinal(el)
      _exp = "(#{_exp}) + (#{_el})"

    return _exp

  # a + 2 = 2 + a
  withEqlSinal: (exp) ->
    exps = exp.split('=')
    exps.clean('')

    if exps.length == 1
      return exps[0]
    else
      if (exps.length == 2)
        exp_l = exps[0]
        exp_r = exps[1]
        return "(#{exp_l}) + (#{exp_r})"
      else
        return 'false' # invalida a expressão.

  validKey: (key) ->
    if (key >= 48 && key <= 57) || (key in @validKeys)
      return true
    else
      if String.fromCharCode(key).toLowerCase() in @variables
        return true
      else
        return false

  keyboardInputEnter: (ev) ->
    unless ( @validKey(ev.which) )
      ev.preventDefault()
      ev.returnValue = false
      @update = false # flag to update display
    else
      @update = true # flag to update display

  updateDisplayFromInput: ->
    if @update
      @updateDisplay()
