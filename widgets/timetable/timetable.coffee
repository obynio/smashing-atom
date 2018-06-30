Batman.mixin Batman.Filters,

  aMomentPlease: (event)->
    start = moment.unix(event.start).utc()
    end = moment.unix(event.end).utc()
    "#{start.format('ddd, HH:mm') + " > " + end.format('HH:mm');}"

class Dashing.Timetable extends Dashing.Widget