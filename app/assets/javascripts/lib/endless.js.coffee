class Carrie.Models.Endless extends Backbone.Model
  url: ->
    @currentPage++
    "#{@get('root_url')}/page/#{@currentPage}"

  initialize: ->
    Carrie.Utils.Loading(@)
    @currentPage = 0
    @fetch
      async: false
      success: =>
        @appendElements()

  currentPage: ->
    @currentPage

  load: ->
    self = @
    $(window).scroll ->
      if (($(window).scrollTop() > ($(document).height() - $(window).height() - 50)))
        if self.currentPage < self.get('total_pages')
          self.fetch
            success: ->
              self.appendElements()

  appendElements: ->
    $.each @get(@get('fecth_array')), (index, el) =>
       @get('collection').add el
