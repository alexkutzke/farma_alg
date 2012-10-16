class Carrie.CompositeViews.EachEnrolled extends Backbone.Marionette.CompositeView
  template: 'teams/each_enrolled'
  tagName: 'section'
  className: 'well'
  itemView: Carrie.Views.EnrolledTeam
  itemViewContainer: 'section.show-los'

  initialize: ->
    los = []
    $.each @model.get('los'), (index, el) =>
      el.team_id = @model.get('id')
      los.push el
    @collection = new Carrie.Collections.TeamLo los
    @icon = 'icon-eye-close'

  events:
    'click .view-los': 'viewLos'

  viewLos: (ev) ->
    ev.preventDefault()
    @toogleIcon(ev)

  toogleIcon: (ev) ->
    $(ev.target).find('i').removeClass(@icon)
    if @icon == 'icon-eye-close'
      @icon = 'icon-eye-open'
    else
      @icon = 'icon-eye-close'

    $(ev.target).find('i').addClass(@icon)
    $(@el).find('section.show-los').toggle()
