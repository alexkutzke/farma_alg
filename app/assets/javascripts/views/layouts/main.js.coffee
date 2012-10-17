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
    'click .toggle-menu': 'toggleMenu'

  toggleMenu: (ev) ->
    ev.preventDefault()
    @menu.toggle()

    if @container.hasClass('span9')
      @container.removeClass('span9')
    else
      @container.addClass('span9')

    if @icon.hasClass('icon-caret-left')
      @icon.removeClass('icon-caret-left')
      @icon.addClass('icon-caret-right')
      title = 'Mostrar menu'
    else
      @icon.removeClass('icon-caret-right')
      @icon.addClass('icon-caret-left')
      title = 'Esconder menu'

    @toggle.attr('data-original-title', title).tooltip('fixTitle').tooltip('show')

  hideMenu: ->
    @menu.hide()
    if @container.hasClass('span9')
      @container.removeClass('span9')

    if @icon.hasClass('icon-caret-left')
      @icon.removeClass('icon-caret-left')
      @icon.addClass('icon-caret-right')

    @toggle.attr('data-original-title', 'Mostrar menu').tooltip('fixTitle')


  onRender: ->
    this.breadcrumb.show @bcb

    @menu = $(@el).find('#main-menu')
    @container = $(@el).find('#main-container')
    @icon = $(@el).find('.toggle-menu i')
    @toggle = $(@el).find('.toggle-menu')
    @toggle.tooltip()

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
