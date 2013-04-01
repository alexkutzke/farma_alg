class Carrie.Views.Breadcrumb extends Backbone.Marionette.ItemView
  template: 'shared/breadcrumb'
  tagName: 'ul'
  className: 'breadcrumb'

  events:
    'click li a': 'showView'

  showView: (ev) ->
    ev.preventDefault()
    Backbone.history.navigate $(ev.target).data('url'), true

  add: (name, url, active_link) ->
    current_url = (Backbone.history.options.root || "") + Backbone.history.fragment

    if active_link
      link = "<li><a href='#' data-url='"+url+"'>"+name+"</a> <span class='divider'>/</span></li>"
    else
      link = "<li class='active'>" + name + "</li>"

    $(@el).append(link)
