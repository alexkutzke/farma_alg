class Carrie.CompositeViews.ExerciseIndex extends Backbone.Marionette.CompositeView
  tagName: 'section'
  template: 'exercises/index'
  itemView: Carrie.Views.ExerciseItem

  events:
    'click #new_exer' : 'new'

  new: (ev) ->
    ev.preventDefault()
    Backbone.history.navigate('/los/'+@model.get('id')+'/exercises/new', true)

  onRender: ->
    @el.id = 'exercises'
    $(@el).find('span i').tooltip()
    url = @collection.url() + '/sort'
    $(@el).sortable
      handle: '.move'
      axis: 'y'
      items: 'article'
      update: (event, ui) ->
        $.post(url, { 'ids' : $(this).sortable('toArray') })
