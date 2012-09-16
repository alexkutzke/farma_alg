class Carrie.Collections.Introductions extends Backbone.Collection
  model: Carrie.Models.Introduction
  url: ->
    '/api/los/' + this.lo.get('id') + '/introductions'
