class Carrie.Views.Welcome extends Backbone.Marionette.ItemView
  template: 'shared/welcome'

  events:
    'submit form': 'signup'

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
