class Carrie.Models.Team extends Backbone.RelationalModel
  urlRoot: '/api/teams'
  paramRoot: 'team'

  defaults:
    lo_ids: []
