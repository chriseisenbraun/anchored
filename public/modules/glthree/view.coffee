# Lib
Three = require 'threejs'
Stats = require 'stats.js'
_ = require 'underscore'
$ = require '../vendor/jquery.coffee'
Backbone = require "../vendor/backbone.coffee"

class GLThreeView extends Backbone.View

  el          : '.canvas-wrapper'
  events      :
    'mousemove': 'onMouseMove'
  canvasColor : 'rgba(0,0,0,1)'
  triangle:
    side: 1
    scale: 2
    translateY: 0.5

  initialize: ->
    _(@).bindAll 'animate'
    @stats = new Stats()
    $('body').append @stats.domElement
    @setUpThree()
    @generateLines()
    @width = $(document).width()
    @height = $(document).height()
    $(document).mousemove

  onMouseMove: (e) ->
    e.preventDefault()
    radius = 2
    xM =  0.5 - (e.clientX / @width)
    #  2   2   2
    # x + z = 1
    #
    @camera.position.x = xM
    @camera.position.y = e.clientY / @height
    @camera.position.z = 2 * Math.sqrt(1 - xM*xM)
    @camera.updateMatrix()
    #mouse3D = projector.unprojectVector(new THREE.Vector3((e.clientX / renderer.domElement.width) * 2 - 1, -(e.clientY / renderer.domElement.height) * 2 + 1, 0.5), camera)
    #ray.direction = mouse3D.subSelf(camera.position).normalize()
    return


  setUpThree: ->
    @scene = new Three.Scene()
    @camera = new Three.PerspectiveCamera(
      75,
      window.innerWidth / window.innerHeight, 0.1, 1000
    )
    @renderer = new Three.WebGLRenderer()
    @renderer.setSize window.innerWidth, window.innerHeight
    @camera.position.z = 2
    #@camera.position.y = 0.5
    @$el.append @renderer.domElement

  generateLines: ->
    geometry = new Three.Geometry
    geometry.vertices.push new Three.Vector3(-@triangle.side, 0, 0)
    geometry.vertices.push new Three.Vector3(0, @triangle.side * 1.5, 0)
    geometry.vertices.push new Three.Vector3(@triangle.side, 0, 0)
    geometry.vertices.push new Three.Vector3(-@triangle.side, 0, 0)
    material = new Three.LineBasicMaterial color: 0xffffff
    @line = new Three.Line geometry, material
    @line.translateY -@triangle.translateY
    #@line.scale.set @triangle.scale, @triangle.scale, @triangle.scale
    @scene.add @line

  animate: ->
    requestAnimationFrame @animate
    # @cube.rotation.x += 0.1
    # @cube.rotation.y += 0.1
    # @line.rotation.x += 0.01
    # @line.rotation.z += 0.01
    @renderer.render @scene, @camera
    @stats.update()

module.exports = GLThreeView
