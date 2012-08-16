class Carrie.Models.UserPasswordReset extends Backbone.Model
  url: '/users/password.json'
  paramRoot: 'user'

  defaults:
    'id': '1'
    'password': ''
    'password_confirmation': ''
