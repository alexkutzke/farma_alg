class Carrie.Views.Layouts.Unauthenticated extends Backbone.Marionette.Layout
  template: 'layouts/unauthenticated'
  regions:
    tabContent: '#tab-content'

  views: {}

  events:
    'click ul.nav-tabs li a': 'switchViews'

  onShow: ->
    this.views.login = Carrie.Views.Unauthenticated.Login
    this.views.signup = Carrie.Views.Unauthenticated.Signup
    this.views.retrievePassword = Carrie.Views.Unauthenticated.RetrievePassword
    this.tabContent.show new this.views.login

  switchViews: (e) ->
    e.preventDefault()
    this.tabContent.show(new this.views[$(e.target).data('content')])
    Backbone.history.navigate $(e.target).data('url'), false

  showView: (view) ->
    $(this.el).find('ul.nav-tabs li').removeClass('active')
    $(this.el).find("ul.nav-tabs li a[data-content='#{view}']").parent().addClass('active')
    this.tabContent.show(new this.views[view])

  resetPassword: (token) ->
    this.tabContent.show new Carrie.Views.Unauthenticated.ResetPassword model: {reset_password_token: token}


Carrie.addInitializer ->
  Carrie.layouts.unauthenticated = new Carrie.Views.Layouts.Unauthenticated()
