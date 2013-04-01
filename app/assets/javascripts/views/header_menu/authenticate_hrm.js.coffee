class Carrie.Views.AuthenticateHRM extends Backbone.Marionette.ItemView
  template: 'shared/header_menu/authenticate_hrm'

  events:
    'click #perfil-link' : 'showPerfil'

  initialize: ->
    $(@el).html(HandlebarsTemplates[@template](@model.toJSON()))

  showPerfil: (e) ->
    e.preventDefault()
    Backbone.history.navigate('/users/perfil', true)

  onRender: ->
    $(@el).find('.btn-sign-out').tooltip
      placement: 'bottom'
