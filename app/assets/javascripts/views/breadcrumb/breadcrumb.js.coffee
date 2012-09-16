class Carrie.Views.Breadcrumb extends Backbone.Marionette.ItemView
  template: 'shared/breadcrumb'
  tagName: 'ul'
  className: 'breadcrumb'

  events:
    'click li a': 'showView'

  showView: (ev) ->
    ev.preventDefault()
    Backbone.history.navigate $(ev.target).data('url'), true

  add: (name, url, last) ->
    current_url = (Backbone.history.options.root || "") + Backbone.history.fragment

    if last
      link = "<li class='active'>" + name + "</li>"
    else
      link = "<li><a href='#' data-url='"+url+"'>"+name+"</a> <span class='divider'>/</span></li>"

    $(@el).append(link)
