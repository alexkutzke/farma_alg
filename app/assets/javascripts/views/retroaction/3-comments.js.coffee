class Carrie.CompositeViews.Retroaction.AnswerComments extends Backbone.Marionette.CompositeView
  tagName: 'section'
  template: 'retroaction/comments'
  itemView: Carrie.Views.Retroaction.AnswerComment
  itemViewContainer: '.comments-list'

  events:
    'click .markdown_link' : 'viewExamples'
    'submit #new_comment' : 'saveComment'

  initialize: ->
    @model.set('user_name', Carrie.currentUser.get('name'))

  #onRender: ->
  #  MathJax.Hub.Queue(["Typeset",MathJax.Hub, @el])

  viewExamples: (ev) ->
    ev.preventDefault()
    $('.markdown_examples').toggle()

  saveComment: (ev) ->
    ev.preventDefault()

    comment = new Carrie.Models.AnswerComment
      answer: @model
      text: $(@el).find('#new_comment').find('textarea').val()

    comment.off('relational:change:answer')
    comment.save comment.attributes,
      async: false
      silent: true
      success: (model, response, options) =>
        @collection.reset(@collection.models)
        $(@el).find('#new_comment').find('textarea').val('')
        $(@el).find('#new_comment').find('.error').html('')
        @changeNumberOfComments()
      error: (model, response, options) =>
        $(@el).find('#new_comment').find('.error').html('não pode ser vazio')
        @collection.remove(model)

  changeNumberOfComments: ->
    $('span.number_of_comments').data('number', @collection.length)
    $('span.number_of_comments').html(Carrie.Utils.Pluralize(@collection.length, 'comentário','comentários'))
