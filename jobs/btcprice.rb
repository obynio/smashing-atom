require 'net/http'
require 'json'
require 'uri'

SCHEDULER.every '1m', allow_overlapping: false do
  uri = URI.parse('https://api.coinbase.com/v2/prices/BTC-EUR/spot')
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  request = Net::HTTP::Get.new(uri.request_uri)
  response = http.request(request)
  json_response = JSON.parse(response.body)
  btc_price = json_response['data']['amount']
  btc_price = '%.2f' % btc_price.delete(',').to_f
  #puts btc_price
  send_event('btcprice', { value: btc_price.to_f} )
end
