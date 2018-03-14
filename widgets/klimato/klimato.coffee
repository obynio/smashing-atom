class Dashing.Klimato extends Dashing.Widget

  onData: (data) ->
    @setBackgroundClassBy parseInt(data.temperature, 10), data.format
