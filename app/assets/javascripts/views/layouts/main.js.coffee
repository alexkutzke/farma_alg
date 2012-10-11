class Carrie.Views.Layouts.Main extends Backbone.Marionette.Layout
  template: 'layouts/main'
  className: 'row-fluid'
  regions:
    content: '#content'
    breadcrumb: '#breadcrumb'

  initialize: ->
    @bcb = new Carrie.Views.Breadcrumb()

  events:
    'click ul.nav-fixed li a[data-url]': 'showView'

  onRender: ->
    this.breadcrumb.show @bcb

  showView: (ev) ->
    ev.preventDefault()

    #if not $(ev.target).parent().hasClass('active')
    Backbone.history.navigate $(ev.target).data('url'), true

  reloadBreadcrumb: ->
    @bcb = new Carrie.Views.Breadcrumb()
    this.breadcrumb.show @bcb

  addBreadcrumb: (name, url, last_link) ->
    @bcb.add(name, url, last_link)

Carrie.addInitializer ->
  Carrie.layouts.main = new Carrie.Views.Layouts.Main()
