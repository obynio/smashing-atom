class Dashing.Btcprice extends Dashing.Widget
  @accessor 'value', Dashing.AnimatedValue
  @accessor 'btcprice', ->
    if @get('value')
      price = parseFloat(@get('value'))
