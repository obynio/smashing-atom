class Dashing.Ratp extends Dashing.Widget
  onData: (data) ->
    for result in data.results
      transportId = Object.keys(result)[0]
      currentResult = result[transportId]
      
      transportId1 = transportId + '-1'
      transportId2 = transportId + '-2'

      element = $("##{transportId}-1").val()
      if not element?
        # First time, build the table
        $(".widget-ratp table")
          .append(@createRow(currentResult.type, currentResult.id, transportId1))
          .append(@createRow(currentResult.type, currentResult.id, transportId2))

      @updateDest(transportId1, currentResult.d1)
      @updateTime(transportId1, currentResult.t1)
      @updateDest(transportId2, currentResult.d2)
      @updateTime(transportId2, currentResult.t2)

  createRow: (type, id, transportId) ->
    cellIcon = $ "<td>"
    cellIcon.addClass "transport"

    imgIcon = $ "<img>"
    imgIcon.attr 'src', 'https://www.ratp.fr/sites/default/files/network/' + type + '/ligne' + @rename(id) + '.svg'
    imgIcon.addClass type
    imgIcon.addClass 'icon'

    cellIcon.append imgIcon

    cellDest = $ "<td>"
    cellDest.addClass 'dest'
    cellDest.attr 'id', transportId + '-dest'

    spanDest = $ "<span>"
    spanDest.attr 'id', transportId + '-dest-span'

    cellDest.append spanDest

    cellTime = $ "<td>"
    cellTime.addClass 'time'
    cellTime.attr 'id', transportId + '-time'

    spanTime = $ "<span>"
    spanTime.attr 'id', transportId + '-time-span'

    cellTime.append spanTime

    row = $ "<tr>"
    row.attr 'id', transportId
    row.append cellIcon
    row.append cellDest
    row.append cellTime

    return row

  updateDest: (id, newValue) ->
    ratp = this
    tdId = "##{id}-dest"
    spanId = "##{id}-dest-span"
    oldValue = $(spanId).html()
    if oldValue != newValue
      $(spanId).fadeOut(->
        $(tdId).css('font-size', '')
        $(this).html(newValue).fadeIn(->
          if outer < scroll
            $(tdId).addClass 'scroll'
          else
            $(tdId).removeClass 'scroll'
          
        )
      )

  updateTime: (id, newValue) ->
    ratp = this
    tdId = "##{id}-time"
    spanId = "##{id}-time-span"
    oldValue = $(spanId).html()
    if oldValue != newValue
      $(spanId).fadeOut(->
        $(this).html(newValue).fadeIn()
      )

  rename: (id) ->
    if id == 'PC1'
      return '97'
    else if id == 'PC3'
      return '99'
    return id