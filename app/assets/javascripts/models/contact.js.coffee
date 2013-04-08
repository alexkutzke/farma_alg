class Carrie.Models.Contact extends Backbone.RelationalModel
  urlRoot: '/api/contacts/'

  paramRoot: 'contact'

  defaults:
    'name': ''
    'email': ''
    'message': ''
