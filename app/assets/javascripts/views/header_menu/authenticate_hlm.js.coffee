class Carrie.Views.AuthenticateHLM extends Backbone.Marionette.ItemView
  template: 'shared/header_menu/authenticate_hlm'

  events:
    'click a': 'show_view'

  show_view: (e) ->
    e.preventDefault()
    Backbone.history.navigate $(e.target).data('url'), true
