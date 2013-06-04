class Carrie.CompositeViews.ExerciseShow extends Backbone.Marionette.CompositeView
  tagName: 'section'
  template: 'exercises/show'
  itemView: Carrie.Views.Question

  initialize: ->
    @collection = @model.get('questions')

  onClose: ->

  beforeClose: ->
    Carrie.CKEDITOR.clear()

  onRender: ->
    #MathJax.Hub.Queue(["Typeset",MathJax.Hub, @el])
    @el.id = @model.get('id')
    $(@el).find('span i').tooltip()
    url = @collection.url() + '/sort'
    $(@el).sortable
      handle: '.move'
      axis: 'y'
      items: 'article'
      update: (event, ui) ->
        $.post(url, { 'ids' : $(this).sortable('toArray') })

  events:
    'click #new-question-link': 'new_question'

  new_question: (ev) ->
    ev.preventDefault()
    form = new Carrie.Views.CreateOrSaveQuestion(exercise: @model)
    $(@el).find('#new_question').html form.render().el

  appendHtml: (collectionView, itemView, index) ->
    $(@el).append(itemView.el) if itemView.model.get('id')
