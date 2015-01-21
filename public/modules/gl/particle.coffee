
class Particle

  color   : 'rgba(255,255,255,0.5)'
  radius  : 1
  velCoef : 0.2

  ###
  Position them randomly on the canvas
  Math.random() generates a random value between 0
  and 1 so we will need to multiply that with the
  canvas width and height.
  ###
  constructor: (@ctx, @screenWidth, @screenHeight) ->
    # Velocity
    @vx = -@velCoef/2 + Math.random() * @velCoef
    @vy = -@velCoef/2 + Math.random() * @velCoef
    @x = Math.random() * @screenWidth
    @y = Math.random() * @screenHeight
  
  ###
  This is the method that will draw the Particle on the
  canvas. It is using the basic fillStyle, then we start
  the path and after we use the `arc` function to
  draw our circle. The `arc` function accepts four
  parameters in which first two depicts the position
  of the center point of our arc as x and y coordinates.
  The third value is for radius, then start angle,
  end angle and finally a boolean value which decides
  whether the arc is to be drawn in counter clockwise or
  in a clockwise direction. False for clockwise.
  ###
  draw: ->
    @ctx.fillStyle = @color
    @ctx.beginPath()
    @ctx.arc @x, @y, @radius, 0, Math.PI * 2, off
    # Fill the color to the arc that we just created
    @ctx.fill()

  distance: (p) ->
    d = dx: @x - p.x, dy: @y - p.y
    length = Math.sqrt d.dx * d.dx + d.dy * d.dy
    d.length = length
    d

  update: ->
    @x += @vx
    @y += @vy

    ###
    We don't want to make the particles leave the
    area, so just change their position when they
    touch the walls of the window
    ###
    if @x + @radius > @screenWidth or @x - @radius < 0
      @vx *= -1
    if @y + @radius > @screenHeight or @y - @radius < 0
      @vy *= -1
    #if @x + @radius > @screenWidth
    #  @x = @radius
    #else
    #  if @x - @radius < 0
    #    @x = @screenWidth - @radius
    #if @y + @radius > @screenHeight
    #  @y = @radius
    #else
    #  if @y - @radius < 0
    #    @y = @screenHeight - @radius

module.exports = Particle
