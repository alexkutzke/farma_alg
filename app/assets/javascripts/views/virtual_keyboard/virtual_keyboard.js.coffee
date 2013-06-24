class Carrie.Views.VirtualKeyBoard extends Backbone.Marionette.ItemView
  template: 'virtual_keyboard/show'
  className: 'virtual-keyboard modal'

  events:
    'click a' : 'setInput'
    
  initialize: ->
    @callback = @options.callback || ->
    $(@el).on 'destroy', =>
      @remove()
 
  onRender: ->
    @input = $($(@el).find('.keyboard-input').first())
    @input.attr('value', @options.currentResp)
    @draggable()
    @x = $(@el).find('#code')
    @code = CodeMirror(@x[0], { mode:  "pascal",  tabSize:2, lineNumbers: true })
    @inputFocus()
    @el

  setInput: (ev) ->
    ev.preventDefault()
    value = $(ev.target).data('value').toString()
    @input.focus()

    switch value
      when 'clean'
        @code.setValue('')
      when 'send'
        @send()

  send: ->
    $(@el).modal('hide')
    #val = @input.val()
    val = @code.getValue()
    @callback val

  inputFocus: ->
    self = @
    setTimeout ( ->
      self.code.refresh()
      self.code.focus()
      self.code.setSize('100%','450')
    ), 100

  draggable: ->
    setTimeout ( =>
      $(@el).draggable()
    ), 100