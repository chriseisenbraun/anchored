Particle = require './particle.coffee'
Line = require './line.coffee'
Backbone = require '../vendor/backbone.coffee'
_ = require 'underscore'

class GLView extends Backbone.View

  particleCount : 100
  particles     : []

  el          : 'canvas'
  canvasColor : 'rgba(0,0,0,1)'

  paintCanvas: ->
    @ctx.fillStyle = @canvasColor
    @ctx.fillRect 0, 0, @width, @height

  ###
  Function to draw everything on the canvas that we'll use when
  animating the whole scene.
  ###
  draw: ->
    # Call the paintCanvas function here so that our canvas
    # will get re-painted in each next frame
    @paintCanvas()
    # Call the function that will draw the balls using a loop
    p.draw() for p in @particles
    #Finally call the update function
    @update()

  # Give every particle some life
  update: ->
    for p in @particles
      p.update()
      for n in @particles
        p.draw()
        l = new Line @ctx, p, n
        l.draw()
    return

  initialize: ->
    _(@).bindAll 'animate'
    @canvas = @$el[0]
    @ctx = @canvas.getContext '2d'
    @width = window.innerWidth
    @height = window.innerHeight
    @canvas.width = @width
    @canvas.height = @height
    for i in [0...@particleCount]
      @particles.push new Particle @ctx, @width, @height

  # Start the main animation loop using requestAnimFrame
  animate: ->
    @draw()
    requestAnimFrame @animate

window.requestAnimFrame = (->
  window.requestAnimationFrame or \
  window.webkitRequestAnimationFrame or \
  window.mozRequestAnimationFrame or \
  window.oRequestAnimationFrame or \
  window.msRequestAnimationFrame or \
  (callback) -> return window.setTimeout callback, 1000 / 60
)()

module.exports = GLView
