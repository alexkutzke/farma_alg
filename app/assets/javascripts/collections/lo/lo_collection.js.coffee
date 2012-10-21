class Carrie.Collections.Lo extends Backbone.Collection
  model: Carrie.Models.Lo
  url: '/api/los'

  initialize: ->
    Carrie.Utils.Loading(@)
