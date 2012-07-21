window.Carrie = new Backbone.Marionette.Application()

Carrie.Views = {}
Carrie.Views.Layouts = {}
Carrie.Models = {}
Carrie.Collections = {}
Carrie.Routers = {}
Carrie.Helpers = {}

Carrie.layouts = {}

Carrie.addRegions
  main: '#main'
  top_menu: '#top_menu'

Carrie.bind 'initialize:after', ->
  Carrie.vent.trigger 'authentication:logged_out'

Carrie.vent.on 'authentication:logged_out', ->
  Carrie.main.show Carrie.layouts.unauthenticated

$ ->
  Carrie.start()
  # BootStrap Tooltip
  $('a[rel=tooltip]').tooltip()
