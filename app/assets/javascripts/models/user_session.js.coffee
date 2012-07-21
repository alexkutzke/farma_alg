class Carrie.Models.UserSession extends Backbone.Model
  url: '/users/sign_in.json'
  paramRoot: 'user'

  defaults:
    'email': ''
    'password': ''
