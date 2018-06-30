require 'net/http'
require 'icalendar'
require 'open-uri'

calendars = {srs: "https://chronosvenger.me/?classe=SRS.ics"}

SCHEDULER.every '10m', :first_in => 0 do |job|

  calendars.each do |cal_name, cal_uri|

    ics  = open(cal_uri) { |f| f.read }
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
        location: e.location.lines.first,
        start: e.dtstart.to_time.to_i,
        end: e.dtend.to_time.to_i
      }
    end

    send_event("timetable_#{cal_name}", {events: events})
  end

end
