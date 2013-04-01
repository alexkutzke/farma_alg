class Carrie.Routers.Answers extends Backbone.Marionette.AppRouter
  appRoutes:
    'answers': 'index'

class Carrie.Controllers.Answers

  index: ->
     Carrie.Helpers.Session.Exists
      func: =>
        Carrie.Utils.Menu.highlight 'answers-link'

        Carrie.layouts.main.loadBreadcrumb
          1: name: 'Objetos de Aprendizagem', url: '/los'
          2: name: 'Respostas', url: ''

        collection = new Carrie.Collections.WrongCorrectAnswers()
        view = new Carrie.CompositeViews.WrongCorrectAnswersIndex
           collection: collection

        Carrie.layouts.main.content.show view
