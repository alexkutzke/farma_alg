class Carrie.Collections.TestCases extends Backbone.Collection
  model: Carrie.Models.TestCase
  url: ->
    exer = @.question.get('exercise')
    '/api/los/' + exer.get('lo').get('id') + '/exercises/' + exer.get('id') + '/questions/' + @.question.get('id') + '/test_cases'

  comparator: (item) ->
    return item.get('input')
