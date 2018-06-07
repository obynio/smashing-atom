require 'benchmark'
require 'timeout'
require 'net/http'
require 'uri'

points = [{x: 1, y: 0}]
last_x = points.last[:x]
latency_uri = URI.parse('http://www.youtube.com')
timeout_in_seconds = 2

SCHEDULER.every '10s' do
    l = timeout_in_seconds
    begin
        Timeout::timeout(timeout_in_seconds) do
            l = Benchmark.realtime { Net::HTTP.get_response(latency_uri) }
        end
    rescue Timeout::Error
    end

    points.shift if points.length >= 100
    last_x += 1
    points << {x: last_x, y: (l * 1000).round}
    send_event('latency', points: points)
end
