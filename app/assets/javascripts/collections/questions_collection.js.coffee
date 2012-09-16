class Carrie.Collections.Questions extends Backbone.Collection
  model: Carrie.Models.Question
  url: ->
    '/api/los/' + this.exercise.get('lo').get('id') + '/exercises/' + @exercise.get('id') + '/questions'
