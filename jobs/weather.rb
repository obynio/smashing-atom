require 'net/http'

# you can find CITY_ID here http://bulk.openweathermap.org/sample/city.list.json.gz
CITY_ID = 2988507

# options: metric / imperial
UNITS   = 'metric'

# create free account on open weather map to get API key
API_KEY = '9d10b6e7ebc982acd50dc989614a5184'

SCHEDULER.every '1m', :first_in => 0 do |job|

  http = Net::HTTP.new('api.openweathermap.org')
  response = http.request(Net::HTTP::Get.new("/data/2.5/weather?id=#{CITY_ID}&units=#{UNITS}&appid=#{API_KEY}"))

  next unless '200'.eql? response.code

  weather_data  = JSON.parse(response.body)
  detailed_info = weather_data['weather'].first
  current_temp  = weather_data['main']['temp'].to_f.round

  send_event('weather', { :temp => "#{current_temp} &deg;#{temperature_units}",
                          :condition => detailed_info['main'],
                          :title => "#{weather_data['name']} Weather",
                          :climacon => climacon_class(detailed_info['id'])})
end


def temperature_units
  'metric'.eql?(UNITS) ? 'C' : 'K'
end

# fun times ;) legend: http://openweathermap.org/weather-conditions
def climacon_class(weather_code)
  case weather_code.to_s
  when /800/
    'sun'
  when /80./
    'cloud'
  when /2.*/
    'lightning'
  when /3.*/
    'drizzle'
  when /5.*/
    'rain'
  when /6.*/
    'snow'
  else
    'sun'
  end
end