class Carrie.Routers.AnswersController

  index: ->
     Carrie.Helpers.Session.Exists
      func: =>
        Carrie.layouts.main.reloadBreadcrumb()
        Carrie.layouts.main.addBreadcrumb('Respostas', '', true)

        collection = new Carrie.Collections.CEAnswers()

        view = new Carrie.CompositeViews.CEAnswerIndex
           collection: collection
        Carrie.layouts.main.content.show view


        #collection.fetch
        #  success: ->
        #    view = new Carrie.CompositeViews.CEAnswerIndex
        #      collection: collection

        #    Carrie.layouts.main.content.show view
        #  error: ->
        #    Carrie.Utils.Alert.error('Problema para carregar as respostas', 3000)

