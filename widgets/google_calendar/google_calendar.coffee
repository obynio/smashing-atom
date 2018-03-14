Batman.mixin Batman.Filters,

  aMomentPlease: (event)->
    start = moment.unix(event.start)
    end = moment.unix(event.end)
    "#{start.format('ddd, HH:mm') + " - " + end.format('HH:mm');}"

class Dashing.GoogleCalendar extends Dashing.Widget
