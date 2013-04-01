class Carrie.Views.UnAuthenticateHRM extends Backbone.Marionette.ItemView
  template: 'shared/header_menu/unauthenticate_hrm'
  tagName: 'ul'
  className: 'nav'

  events:
    'click a': 'show_view'

  show_view: (e) ->
    e.preventDefault()
    Backbone.history.navigate $(e.target).data('url'), true
