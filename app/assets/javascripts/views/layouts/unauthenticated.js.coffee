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
    #this.views.retrievePassword = Carrie.Views.Unauthenticated.RetrievePassword;
    this.tabContent.show new this.views.login

  switchViews: (e) ->
    e.preventDefault()
    this.tabContent.show(new this.views[$(e.target).data('content')])

Carrie.addInitializer ->
  Carrie.layouts.unauthenticated = new Carrie.Views.Layouts.Unauthenticated()
