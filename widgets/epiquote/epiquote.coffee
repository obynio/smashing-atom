class Dashing.Epiquote extends Dashing.Widget

  ready: ->
    @currentIndex = 0
    @headlineElem = $(@node).find('.container')
    @nextComment()
    @startCarousel()

  onData: (data) ->
    @currentIndex = 0

  startCarousel: ->
    setInterval(@nextComment, 13000)

  nextComment: =>
    headlines = @get('headlines')
    if headlines
      @headlineElem.fadeOut =>
        @currentIndex = (@currentIndex + 1) % headlines.length
        @set 'current_headline', headlines[@currentIndex]
        $(@node).find('.name').html(headlines[@currentIndex].name)
        $(@node).find('.description').html(headlines[@currentIndex].description)
        $(@node).find('.quotation').html(headlines[@currentIndex].quote)
        @headlineElem.fadeIn()
