class Line

  minDist: 100
  maxDist: 0

  constructor: (@ctx, @p1, @p2) ->
    return

  draw: ->
    dist = @p1.distance @p2
    return if dist.length > @minDist or dist.length < @maxDist
    # Draw the line
    @ctx.beginPath()
    @ctx.strokeStyle = "rgba(255,255,255,#{1.2 - dist.length / @minDist})"

    @ctx.moveTo @p1.x, @p1.y
    @ctx.lineTo @p2.x, @p2.y
    @ctx.stroke()
    @ctx.closePath()

    # Some acceleration for the partcles
    # depending upon their distance
    ax = 0#dist.dx / 20000
    ay = 0#dist.dy / 20000
    
    # Apply the acceleration on the particles
    @p1.vx -= ax
    @p1.vy -= ay
    @p2.vx += ax
    @p2.vy += ay

module.exports = Line
