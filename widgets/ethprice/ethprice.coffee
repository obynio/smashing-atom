class Dashing.Ethprice extends Dashing.Widget
  @accessor 'value', Dashing.AnimatedValue
  @accessor 'ethprice', ->
    if @get('value')
      price = parseFloat(@get('value'))
