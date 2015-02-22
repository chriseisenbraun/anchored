# Libraries

$ = require '../vendor/jquery.coffee'

class HitPoint

  constructor: (@name, @elem, @side, @offset) -> return

  attach: ->
    @elem = $(@elem)
    @computeLoc @side

  computeLoc: ->
    # Top
    if @side is 'top'
      @y = @elem.position().top + @offset
    # Bottom
    if @side is 'bottom'
      @y = @elem.position().top + @elem.height() + @offset
    return

  contains: (yTop, yBottom) ->
    if yTop > yBottom
      tmp = yBottom
      yBottom = yTop
      yTop = tmp
    yTop <= @y and yBottom >= @y

module.exports = HitPoint
