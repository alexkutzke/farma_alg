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
    @inputFocus()
    x = @el
    langs = {}
    if @options.languages
      for i in @options.languages
        if i == "c"
          langs["c"] = "C"
        else if i == "pas"
          langs["pas"] = "Pascal"
        else if i == "rb"
          langs["rb"] = "Ruby"

    mode = "pascal"
    select = $(@el).find("select#languages").val()
    if  select == "c"
        mode = "clike"
      else if select == "pas"
        mode = "pascal"
      else if select == "rb"
        mode = "ruby"

    $(@el).find("select#languages").append(new Option("Escolha uma linguagem", ""))
    $.each(langs, (val,text) ->
      $(x).find("select#languages").append(new Option(text, val))
    )
    $(@el).find("select#languages").val(@options.lang)

    @c = $(@el).find('#code')
    @code = CodeMirror(@c[0], { mode: mode,  tabSize:2, lineNumbers: true })
    @code.setValue(@options.currentResp)
    
    c = @code
    $(@el).find("select#languages").change( ->
      if $(this).val() == "c"
        c.setOption("mode","clike")
      else if $(this).val() == "pas"
        c.setOption("mode","pascal")
      else if $(this).val() == "rb"
        c.setOption("mode","ruby")
    )
    @el

    #editAreaLoader.init
    #  id: "code_text",          
    #  syntax: "ruby",
    #  start_highlight: true,
    #  show_line_colors: true, 
    #  replace_tab_by_spaces: 2,
    #  allow_toggle: false,
    #  toolbar: "",
    #  begin_toolbar: "",
    #  end_toolbar : ""
    

  setInput: (ev) ->
    ev.preventDefault()

    value = $(ev.target).data('value').toString()
    @input.focus()

    switch value
      when 'cancel'
        $(@el).modal('hide')
        @remove()
      when 'clean'
        @code.setValue('')
      when 'send'
        if $(@el).find("select#languages").val() == ""
          alert('Escolha uma linguagem.')
          $(@el).find("#languages").focus()
          $(@el).find("#languages").attr('required','required')
          return false
        else
          @send()

  send: ->
    $(@el).modal('hide')
    val = @code.getValue()
    
    @callback val,$(@el).find("select#languages").val()

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