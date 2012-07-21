Backbone.Marionette.Renderer.render = (template, data) ->
  HandlebarsTemplates[template](data)
