class Carrie.Views.CreateOrSaveTeam extends Backbone.Marionette.ItemView
  template: 'teams/form'

  events:
    'submit form': 'create'

  initialize: ->
    @model = new Carrie.Models.Team() if not @model
    this.modelBinder = new Backbone.ModelBinder()

  onRender: ->
    @modelBinder.bind(this.model, this.el)
    @checkboxes()

  create: (ev) ->
    ev.preventDefault()
    Carrie.Helpers.Notifications.Form.clear()
    Carrie.Helpers.Notifications.Form.loadSubmit()

    checkboxes = $(@el).find('.checkboxes input[type="checkbox"]')
    lo_ids = checkboxes.serializeArray().map (el) ->
      el.value

    @model.set('lo_ids', lo_ids)

    @model.save @model.attributes,
      wait: true
      success: (lo, response) =>
        Carrie.Helpers.Notifications.Form.resetSubmit()

        Backbone.history.navigate "/teams/created", true
        Carrie.Helpers.Notifications.Top.success 'Turma criada com sucesso!', 4000

      error: (model, response, options) =>
        result = $.parseJSON(response.responseText)

        Carrie.Helpers.Notifications.Form.before 'Existe erros no seu formulário'
        Carrie.Helpers.Notifications.Form.showErrors(result.errors, @el)
        Carrie.Helpers.Notifications.Form.resetSubmit()

  checkboxes: ->
    obj = $(@el).find('div.checkboxes')
    lo_ids = @model.get('lo_ids')
    los = new Carrie.Collections.Los()
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
