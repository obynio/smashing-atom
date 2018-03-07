Batman.mixin Batman.Filters,

  startText: (str_start)->
    start = moment.unix(str_start)
    "#{start.locale('fr').format('LT')}"

class Dashing.GoogleCalendar extends Dashing.Widget
