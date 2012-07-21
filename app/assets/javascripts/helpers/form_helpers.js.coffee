Carrie.Helpers.FormHelpers = {}

Carrie.Helpers.FormHelpers.fieldHelp = (message) ->
  HandlebarsTemplates['shared/form_field_help']
    'message': message
