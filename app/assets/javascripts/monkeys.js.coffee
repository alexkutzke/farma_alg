Backbone.Marionette.Renderer.render = (template, data) ->
  HandlebarsTemplates[template](data)

Handlebars.registerHelper 'each_with_index', (array, fn) ->
  buffer = ''
  for i in array
    item = i
    item.index = _i
    buffer += fn(item)
  buffer

Handlebars.registerHelper 'safe', (text) ->
  #text = Handlebars.Utils.escapeExpression(text)

  return new Handlebars.SafeString(text)

Handlebars.registerHelper 'ifCond', (e1, e2, options) ->
  if e1 == e2
    return options.fn(this)

  return options.inverse(this)
