require_relative 'ratp_utils'

# Uncomment and define transports below
# (or alternatively, define them in config/settings.rb)

TRANSPORTS = [
  Transport.new(Type::BUS, '185', 'Roger Salengro - Fontainebleau', 'Choisy Sud'),
  Transport.new(Type::METRO, '7', 'Porte d\'Italie', 'La Courneuve-8-Mai-1945'),
  Transport.new(Type::METRO, '7', 'Porte d\'Italie', 'Mairie d\'Ivry / Villejuif-Louis Aragon'),
  Transport.new(Type::TRAM, '3a', 'Porte d\'Italie', 'Porte de Vincennes'),
  Transport.new(Type::TRAM, '3a', 'Porte d\'Italie', 'Pont Garigliano - Hopital Europeen George Pompidou'),
  Transport.new(Type::BUS, '185', 'Roger Salengro - Fontainebleau', 'Choisy Sud'),
  Transport.new(Type::BUS, '131', 'Roger Salengro - Fontainebleau', 'Rungis - la Fraternelle RER'),
  Transport.new(Type::NOCTILIEN, '15', 'Roger Salengro - Fontainebleau', 'Villejuif - Louis Aragon-Metro'),
]

# Init and Validate stations and destinations
stations = {}
directions = {}

TRANSPORTS.each do |transport|
  key = line_key(transport)
  if stations[key].nil?
    stations[key] = read_stations(transport.type[:api], transport.number)
  end

  if stations[key][transport.stop].nil?
    raise ArgumentError, "Unknown stop #{transport.stop}, possible values are #{stations[key].keys}"
  end

  if directions[key].nil?
    directions[key] = read_directions(transport.type[:api], transport.number, stations[key], transport.stop)
  end

  if directions[key][transport.destination].nil?
    raise ArgumentError, "Unknown destination #{transport.destination}, possible values are #{directions[key].keys}"
  end
end

SCHEDULER.every '10s', first_in: 0 do
  results = []

  TRANSPORTS.each do |transport|
    line_key = line_key(transport)
    type = transport.type[:api]
    id = transport.number
    stop = stations[line_key][transport.stop]
    dir = directions[line_key][transport.destination]

    first_destination, first_time, second_destination, second_time = read_timings(type, id, stop, dir)

    first_time_parsed, second_time_parsed = reword(first_time, second_time)
    first_destination_parsed, second_destination_parsed = reword_destination(first_destination, second_destination)

    ui_type = transport.type[:ui]
    stop_escaped = stop.delete('+').delete('\'')

    key = "#{ui_type}-#{id}-#{stop_escaped}-#{dir}"

    results.push(
      key => {
        type: ui_type,
        id: id,
        d1: first_destination_parsed, t1: first_time_parsed,
        d2: second_destination_parsed, t2: second_time_parsed
      }
    )
  end

  send_event('ratp', results: results)
end