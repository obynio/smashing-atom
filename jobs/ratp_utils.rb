require 'net/http'
require 'json'

API_HOME = 'https://api-ratp.pierre-grimaud.fr/v3'.freeze

USER_FRIENDLY_MESSAGES = [
  ['INTERROMPU', 'ARRET NON DESSERVI'], ['Interrompu', 'N/Desservi'],

  ['INTERROMPU', 'INTERROMPU'], ['Interrompu', 'Interrompu'],
  ['INTERROMPU', 'MANIFESTATION'], ['Interrompu', 'Manifestation'],
  ['INTERROMPU', 'INTEMPERIES'], ['Interrompu', 'Intempéries'],

  ['ARRET NON DESSERVI', 'ARRET NON DESSERVI'], ['N/Desservi', 'N/Desservi'],
  ['ARRET NON DESSERVI', 'MANIFESTATION'], ['N/Desservi', 'Manifestation'],
  ['ARRET NON DESSERVI', 'DEVIATION'], ['N/Desservi', 'Déviation'],

  ['NON ASSURE', 'NON ASSURE'], ['Non Assuré', 'Non Assuré'],
  ['NON ASSURE', 'MANIFESTATION'], ['Non Assuré', 'Manifestation'],
  ['NON ASSURE', 'INTEMPERIES'], ['Non Assuré', 'Intempéries'],

  ['CIRCULATION DENSE', 'MANIFESTATION'], ['Circul Dense', 'Manifestation'],

  ['INTEMPERIES', 'INTEMPERIES'], ['Intempéries', 'Intempéries'],

  ['INFO INDISPO ....'], ['Indispo', 'Indispo'],

  ['SERVICE TERMINE'], ['Terminé', 'Terminé'],
  ['TERMINE'], ['Terminé', 'Terminé'],

  ['SERVICE', 'NON COMMENCE'], ['N/Commencé', 'N/Commencé'],
  ['SERVICE NON COMMENCE'], ['N/Commencé', 'N/Commencé'],
  ['NON COMMENCE'], ['N/Commencé', 'N/Commencé']
]

Transport = Struct.new(:type, :number, :stop, :destination)

class Type
  METRO = { api: 'metros', ui: 'metro' }.freeze
  BUS = { api: 'bus', ui: 'bus' }.freeze
  RER = { api: 'rers', ui: 'rer' }.freeze
  TRAM = { api: 'tramways', ui: 'tram' }.freeze
  NOCTILIEN = { api: 'noctiliens', ui: 'noctilien' }.freeze
end

def line_key(transport)
  transport.type[:api] + '-' + transport.number
end

private def get_as_json(path)
  response = Net::HTTP.get_response(URI(path))
  JSON.parse(response.body)
end

def read_stations(type, id)
  stations = {}
  json = get_as_json("#{API_HOME}/stations/#{type}/#{id}?_format=json")
  json['result']['stations'].each do |station|
    stations[station['name']] = station['slug']
  end
  stations
end

def read_directions(type, id, stations, stop)
  json = get_as_json("#{API_HOME}/destinations/#{type}/#{id}?_format=json")

  destinations = json['result']['destinations']

  if type == 'bus' or type == 'tramways'
    return find_bus_directions(destinations, stations, type, id, stop)
  else
    return find_regular_directions(destinations)
  end
end

def find_bus_directions(destinations, stations, type, id, stop)
  directions = {}
  # Bug on RATP side for buses - not all directions are correct
  # We take one destination, and check for destination A
  # If we get ambiguous station (400), it means that A is the direction itself
  # Otherwise, it means that A is the other direction
  # Yet it happens, sometimes, that both return a timing

  possible_directions = %w[A R]

  destinations.each_index do |index|
    destination = destinations[index]
    other_destination = destinations[(index + 1) % 2]

    possible_directions.each_index do |index_direction|
      direction = possible_directions[index_direction]
      other_direction = possible_directions[(index_direction + 1) % 2]

      schedule = get_as_json("#{API_HOME}/schedules/#{type}/#{id}/#{stations[stop]}/#{direction}?_format=json")
      if schedule['result']['code'] == 400
        directions[destination['name']] = direction
        directions[other_destination['name']] = other_direction
        return directions
      end
    end
  end

  # Otherwise, fallback to default
  find_regular_directions(destinations)
end

def find_regular_directions(destinations)
  directions = {}
  destinations.each do |destination|
    directions[destination['name']] = destination['way']
  end
  directions
end

def read_timings(type, id, stop, dir)
  json = get_as_json("#{API_HOME}/schedules/#{type}/#{id}/#{stop}/#{dir}?_format=json")
  schedules = json['result']['schedules']

  if schedules.length >= 2
    [schedules[0]['destination'],
     schedules[0]['message'],
     schedules[1]['destination'],
     schedules[1]['message']]
  elsif schedules.length == 1
    [schedules[0]['destination'],
     schedules[0]['message'],
     '',
     '']
  else
    raise "Unable to parse #{json}"
  end
end

def reword(first_time, second_time)
  USER_FRIENDLY_MESSAGES.each_index do |i|
    if (i % 2).zero?
      messages = USER_FRIENDLY_MESSAGES[i]
      if (messages.length == 1 && (first_time == messages[0] || second_time == messages[0])) || (messages.length == 2 && ((first_time == messages[0] && second_time == messages[1]) || (first_time == messages[1] && second_time == messages[0])))
        return USER_FRIENDLY_MESSAGES[i + 1]
      end
    end
  end

  first_time_parsed = shortcut(first_time)
  second_time_parsed =
    case second_time
    when 'DERNIER PASSAGE', 'PREMIER PASSAGE' then ''
    else shortcut(second_time)
    end
  [first_time_parsed, second_time_parsed]
end

def reword_destination(first_destination, second_destination)
  [first_destination, second_destination]
end

private def shortcut(text)
  case text
  when "Train a l'approche", "Train à l'approche", "A l'approche" then 'Approche'
  when 'Train a quai', 'Train à quai' then 'Quai'
  when 'Train retarde' then 'Retardé'
  when "A l'arret" then 'Arrêt'
  when 'Train arrete' then 'Arrêté'
  when 'Service Termine', 'Service termine' then 'Terminé'
  when 'PERTURBATIONS' then 'Perturbé'
  when 'BUS SUIVANT DEVIE' then 'Dévié'
  else text
  end
end