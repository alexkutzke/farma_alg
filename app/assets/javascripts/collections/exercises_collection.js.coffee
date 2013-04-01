class Carrie.Collections.Exercises extends Backbone.Collection
  model: Carrie.Models.Exercise
  url: ->
    '/api/los/' + this.lo.get('id') + '/exercises'
