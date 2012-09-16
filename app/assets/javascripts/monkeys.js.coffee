Backbone.Marionette.Renderer.render = (template, data) ->
  HandlebarsTemplates[template](data)

Handlebars.registerHelper 'each_with_index', (array, fn) ->
  buffer = ''
  for i in array
    item = i
    item.index = _i
    buffer += fn(item)
  buffer
