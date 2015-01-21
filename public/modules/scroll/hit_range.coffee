HitPoint = require './hit_point.coffee'

class HitRange

  constructor: (name, start, end) ->
    @name  = name
    @start = start
    @end   = end
    if @start > @end
      tmp = @end
      @start = @end
      @start = tmp

  attach: ->
    @start.attach()
    @end.attach()

  contains: (point) ->
    if point instanceof HitPoint
      point.y >= @start.y and point.y <= @end.y
    else
      point >= @start.y and point <= @end.y

  progress: ->
    currentScroll = $(document).scrollTop()
    return (@end.y - currentScroll) / (@end.y - @start.y)

module.exports = HitRange
