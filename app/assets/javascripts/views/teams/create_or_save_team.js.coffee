class Carrie.Views.CreateOrSaveTeam extends Backbone.Marionette.ItemView
  template: 'teams/form'

  events:
    'submit form': 'create'

  initialize: ->
    if not @model
      @model = new Carrie.Models.Team()

    this.modelBinder = new Backbone.ModelBinder()

  onRender: ->
    @modelBinder.bind(this.model, this.el)
    @checkboxes()

  create: (ev) ->
    ev.preventDefault()
    Carrie.Utils.Alert.clear()

    checkboxes = $(@el).find('.checkboxes input[type="checkbox"]')
    lo_ids = checkboxes.serializeArray().map (el) ->
      el.value
    @model.set('lo_ids', lo_ids)

    @model.save @model.attributes,
      wait: true
      success: (lo, response) =>
        $(@el).find('input.btn-primary').button('reset')
        Backbone.history.navigate "/teams/created", true

        Carrie.Utils.Alert.success('Turma criada com sucesso!', 3000)

      error: (lo, response) =>
        result = $.parseJSON(response.responseText)

        msg = Carrie.Helpers.Notifications.error('Existe erros no seu formulário')
        $(@el).find('form').before(msg)
        Carrie.Utils.Alert.showFormErrors(result.errors, @el)

        $(@el).find('input.btn-primary').button 'reset'

  checkboxes: ->
    obj = $(@el).find('div.checkboxes')
    lo_ids = @model.get('lo_ids')
    los = new Carrie.Collections.Lo()
    self = @

    los.fetch
      success: (collection, resp) ->
        column = $('<div class="span4"></div>')

        $.each collection.models, (index, el) ->
          checkbox = self.checkbox(el.get('name'), el.get('id'), lo_ids)
          if index != 0 && index % 5 == 0
            obj.append column
            column = $('<div class="span4"></div>')
          column.append checkbox

        obj.append column

  checkbox: (label, id, ids)->
    if jQuery.inArray(id, ids) != -1
      checked = 'checked'
    else
      checked = ''
    checkbox = "<label class='checkbox'>" +
                 "<input type='checkbox' name='lo_ids' value='#{id}' #{checked} >" +
                 " #{label} " +
               "</label>"
    checkbox
