require 'net/http'
require 'icalendar'
require 'open-uri'

# https://chronosvenger.me/?classe=SRS.ics
# https://ichronos.net/feed/SRS.ics
calendars = {srs: "https://ichronos.net/feed/SRS.ics"}

SCHEDULER.every '30m', :first_in => 0 do |job|

  calendars.each do |cal_name, cal_uri|

    ics  = open(cal_uri, 'User-Agent' => 'Atom') { |f| f.read }
    cal = Icalendar::Calendar.parse(ics).first
    events = cal.events

    # select only current and upcoming events
    now = Time.now
    events = events.select{ |e| e.dtend.to_time > now }

    # sort by start time
    events = events.sort{ |a, b| a.dtstart.to_time <=> b.dtstart.to_time }[0..4]

    events = events.map do |e|
      {
        title: e.summary,
        location: e.location ? e.location.tr('.', '') : '',
        start: e.dtstart.to_time.to_i,
        end: e.dtend.to_time.to_i
      }
    end

    send_event("timetable_#{cal_name}", {events: events})
  end

end
