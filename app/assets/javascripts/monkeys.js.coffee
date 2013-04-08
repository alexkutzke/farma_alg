Backbone.Marionette.Renderer.render = (template, data) ->
  HandlebarsTemplates[template](data)

Handlebars.registerHelper 'each_with_index', (array, fn) ->
  buffer = ''
  for i in array
    item = i
    item.index = _i
    buffer += fn.fn(item)
  buffer

Handlebars.registerHelper 'safe', (text) ->
  #text = Handlebars.Utils.escapeExpression(text)
  return new Handlebars.SafeString(text)

Handlebars.registerHelper 'ifCond', (e1, e2, options) ->
  if e1 == e2
    return options.fn(this)

  return options.inverse(this)

Handlebars.registerHelper 'include',(template, options) ->
  #Find the partial in question.
  partial = Handlebars.partials[template]

  # Build the new context; if we don't include `this` we get functionality
  # similar to {% include ... with ... only %} in Django.
  context = _.extend({}, this, options.hash)

  #Render, marked as safe so it isn't escaped.
  return new Handlebars.SafeString(partial(context))
