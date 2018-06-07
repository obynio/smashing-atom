
require 'open-uri'
require 'json'

# Unofficial API but it works great
API = "https://api-ratp.pierre-grimaud.fr/v3/schedules/"

def get_next(type, path, row)
    url = "#{API}#{type}/#{path}"
    output = open(url)
    timetables = JSON.parse(output.read)
    schedules = timetables['result']['schedules']
    if schedules.count >= row
        if schedules[row]['message'] == "A l'approche"
            return "0"
        else
            next_one = schedules[row]['message'].scan(/\d+/).first
            return "-" if next_one.to_s.empty?
            next_one
        end
    else
        return "?"
    end
end

SCHEDULER.every '10s', first_in: 0 do |job|
    time = Time.new
    if 0 < time.hour && time.hour < 5
        lines = [
            {
                name: "Noct 15",
                icon: "ratp_noct_15.png",
                in: {name: "Gabriel Peri", values: get_next('noctiliens', '15/dauphin+++anatole+france/R', 0)},
                out: {name: "Gabriel Peri", values: get_next('noctiliens', '15/dauphin+++anatole+france/R', 1)}
            },
            {
                name: "Noct 22",
                icon: "ratp_noct_22.png",
                in: {name: "Châtelet", values: get_next('noctiliens', '22/dauphin+++anatole+france/R', 0)},
                out: {name: "Châtelet", values: get_next('noctiliens', '22/dauphin+++anatole+france/R', 1)}
            }
        ]
    else
        lines = [
            {
                name: "Bus 131",
                icon: "ratp_bus_131.png",
                in: {name: "Pt. Italie", values: get_next('bus', '131/ambroise+croizat/R', 0)},
                out: {name: "Pt. Italie", values: get_next('bus', '131/ambroise+croizat/R', 1)}
            },
            {
                name: "Metro 7",
                icon: "ratp_metro_7.png",
                in: {name: "Courneuve", values: get_next('metros', '7/villejuif+leo+lagrange/R', 0)},
                out: {name: "Courneuve", values: get_next('metros', '7/villejuif+leo+lagrange/R', 1)}
            }
        ]
    end
    send_event("ratp", {items: lines})
end