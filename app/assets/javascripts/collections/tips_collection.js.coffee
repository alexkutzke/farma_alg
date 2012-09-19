class Carrie.Collections.Tips extends Backbone.Collection
  model: Carrie.Models.Tip
  url: ->
    exer = @.question.get('exercise')
    '/api/los/' + exer.get('lo').get('id') + '/exercises/' + exer.get('id') + '/questions/' + @.question.get('id') + '/tips'

  comparator: (item) ->
    return -item.get('number_of_tries')
