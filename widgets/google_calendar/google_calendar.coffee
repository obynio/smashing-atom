Batman.mixin Batman.Filters,

  aMomentPlease: (event)->
    start = moment.unix(event.start)
    end = moment.unix(event.end)
    "#{start.format('ddd, HH:MM') + " - " + end.format('HH:MM');}"

class Dashing.GoogleCalendar extends Dashing.Widget
