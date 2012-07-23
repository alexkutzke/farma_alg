class Carrie.Models.UserRegistration extends Backbone.Model
  url: '/users.json'
  paramRoot: 'user'

  defaults:
    'name': ''
    'email': ''
    'password': ''
    'password_confirmation': ''
