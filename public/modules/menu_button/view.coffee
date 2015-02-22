_ = require 'underscore'
require 'velocity'
Backbone = require "../vendor/backbone.coffee"

class MenuButtonView extends Backbone.View

  animationTime: 150
  animationAlgo: 'swing'

  el: '.menu-button'

  events:
    'click': 'onClick'

  initialize: ->
    _(@).bindAll 'onAnimationFinished'
    @isMenuShowing = off

  onClick: (e) ->
    if @isMenuShowing == off
      @closeMode()
    else
      @hamburgerMode()
    @trigger 'interactionStart', @isMenuShowing

  onAnimationFinished: ->
    @trigger 'interactionEnd', @isMenuShowing
    console.log 'animation finished'

  closeMode: ->
    @isMenuShowing = on
    @$('.top').velocity
      rotateZ    : 45
      translateY : 4
      translateX : 9
    , @animationTime, @animationAlgo
    @$('.bottom').velocity
      rotateZ    : -45
      translateY : -4
      translateX : 9
    , @animationTime, @animationAlgo
    @$('.middle').velocity
      opacity: 0
    , @animationTime, @animationAlgo, @onAnimationFinished

  hamburgerMode: (silent) ->
    @isMenuShowing = off
    @$('.top').velocity
      rotateZ    : 0
      translateY : 0
      translateX : 0
    , @animationTime, @animationAlgo
    @$('.bottom').velocity
      rotateZ    : 0
      translateY : 0,
      translateX : 0
    , @animationTime, @animationAlgo
    @$('.middle').velocity
      opacity: 1
    , @animationTime, @animationAlgo, =>
      @onAnimationFinished() if silent != on

module.exports = MenuButtonView
