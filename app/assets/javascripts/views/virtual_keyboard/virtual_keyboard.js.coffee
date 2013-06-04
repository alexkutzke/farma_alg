class Carrie.Views.VirtualKeyBoard extends Backbone.Marionette.ItemView
  template: 'virtual_keyboard/show'
  className: 'virtual-keyboard modal'

  events:
    'click a' : 'setInput'
    
  initialize: ->
    console.log(@options)
    @callback = @options.callback || ->
    $(@el).on 'destroy', =>
      @remove()
 
  onRender: ->
    @input = $($(@el).find('.keyboard-input').first())
    @input.attr('value', @options.currentResp)
    @inputFocus()
    @draggable()
    @el

  setInput: (ev) ->
    ev.preventDefault()
    value = $(ev.target).data('value').toString()
    @input.focus()

    switch value
      when 'clean'
        @input.val('')
      when 'send'
        @send()

  send: ->
    $(@el).modal('hide')
    val = @input.val()
    @callback val

  inputFocus: ->
    self = @
    setTimeout ( ->
      self.input.focus()
    ), 100

  draggable: ->
    setTimeout ( =>
      $(@el).draggable()
    ), 100