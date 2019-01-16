class Dashing.Weather extends Dashing.Widget

  ready: ->
    # This is fired when the widget is done being rendered

  onData: (data) ->
    if data.climacon
      # reset classes
      $('h2.climacon').attr 'class', "climacon #{data.climacon}"