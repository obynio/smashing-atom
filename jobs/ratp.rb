
require 'open-uri'
require 'json'

# Unofficial API but it works great
API = "https://api-ratp.pierre-grimaud.fr/v3/schedules/"

def get_next(type, path, row)
    url = "#{API}#{type}/#{path}"
    output = open(url)
    timetables = JSON.parse(output.read)
    next_one = timetables['result']['schedules'][row]['message'].scan(/\d+/).first
    return "-" if next_one.to_s.empty?
    next_one
end

SCHEDULER.every '1m', first_in: 0 do |job|
    time = Time.new
    if 0 < time.hour && time.hour < 5
        lines = [
            {
                name: "Noct 15",
                icon: "ratp_noct_15.png",
                in: {name: "Asnière", values: get_next('noctiliens', '15/roger+salengro-fontainebleau/R', 0)},
                out: {name: "Asnière", values: get_next('noctiliens', '15/roger+salengro-fontainebleau/R', 1)}
            },
            {
                name: "Noct 22",
                icon: "ratp_noct_22.png",
                in: {name: "Châtelet", values: get_next('noctiliens', '22/roger+salengro-fontainebleau/R', 0)},
                out: {name: "Châtelet", values: get_next('noctiliens', '22/roger+salengro-fontainebleau/R', 1)}
            }
        ]
    else
        lines = [
            {
                name: "Bus 131",
                icon: "ratp_bus_131.png",
                in: {name: "Pt. Italie", values: get_next('bus', '131/roger+salengro-fontainebleau/R', 0)},
                out: {name: "Pt. Italie", values: get_next('bus', '131/roger+salengro-fontainebleau/R', 1)}
            },
            {
                name: "Metro 7",
                icon: "ratp_metro_7.png",
                in: {name: "Courneuve", values: get_next('metros', '7/porte+d+italie/R', 0)},
                out: {name: "Courneuve", values: get_next('metros', '7/porte+d+italie/R', 1)}
            }
        ]
    end
    send_event("ratp", {items: lines})
end