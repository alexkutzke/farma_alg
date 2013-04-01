class Carrie.CompositeViews.IntroductionIndex extends Backbone.Marionette.CompositeView
  tagName: 'section'
  template: 'introductions/index'
  itemView: Carrie.Views.IntroductionShow

  events:
    'click #new_intro' : 'new'

  new: (ev) ->
    ev.preventDefault()
    Backbone.history.navigate("/los/#{@model.get('id')}/introductions/new", true)

  onRender: ->
    @el.id = 'introductions'
    $(@el).find('span i').tooltip()
    url = @collection.url() + '/sort'

    $(@el).sortable
      handle: '.move'
      axis: 'y'
      items: 'article'
      update: (event, ui) ->
        $.post(url, { 'ids' : $(this).sortable('toArray') })
