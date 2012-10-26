class Carrie.Routers.AnswersController

  index: ->
     Carrie.Helpers.Session.Exists
      func: =>
        Carrie.Utils.Menu.show 'answers-link'
        Carrie.layouts.main.reloadBreadcrumb()
        Carrie.layouts.main.addBreadcrumb('Respostas', '', true)

        collection = new Carrie.Collections.CEAnswers()

        view = new Carrie.CompositeViews.CEAnswerIndex
           collection: collection
        Carrie.layouts.main.content.show view
