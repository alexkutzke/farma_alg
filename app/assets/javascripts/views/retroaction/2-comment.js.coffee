class Carrie.Views.Retroaction.AnswerComment extends Backbone.Marionette.ItemView
  template: 'retroaction/comment'
  tagName: 'article'

  events:
    'click .destroy' : 'destroy'

  destroy: (ev) ->
    ev.preventDefault()
    msg = 'Tem certeza?'
    bootbox.confirm msg, (confirmed) =>
      if confirmed
        @model.destroy
          wait: true
          success: (model, response) =>
            $(@el).fadeOut(800, 'linear')
            @changeNumberOfComments()
          error: (response, status) =>
            $(@el).find('.destroy').remove()
            Carrie.Utils.Alert.error('Tempo de remoção expirado!', 3000)

  changeNumberOfComments: ->
    n = $('span.number_of_comments').data('number') - 1
    $('span.number_of_comments').data('number', n)
    $('span.number_of_comments').html(Carrie.Utils.Pluralize(n, 'comentário','comentários'))
