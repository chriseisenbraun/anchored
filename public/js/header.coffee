_ = require 'underscore'
require 'velocity'
Backbone = require './backbone.coffee'

class HeaderView extends Backbone.View

  animationTime: 500
  animationAlgo: 'ease-out'
  translation  : 2

  el: 'header'

  initialize: ->
    # @animateScrollMore()
    @animateLogoInitial()


  animateLogoInitial: ->
    @$('.scroll-down').velocity translateY: 20, opacity: 0, 0
    @$('.logo').velocity translateY: -50, scale: 1.5, opacity: 0, 0
    @$('.logo-extra').velocity scaleY: 1, 0
    # @$('.logo').velocity
    #   translateY  : -10
    #   opacity: 1
    # , @animationTime / 2, @animationAlgo
    @$('.logo').velocity
      translateY : 0
      opacity    : 1
      scale      : 1
    , @animationTime, @animationAlgo, => @animateLogoAnchor()

  animateLogoAnchor: ->
    @$('.logo-extra').velocity
      scaleY: 1.5
    , @animationTime, @animationAlgo, => @showScrollMore()
    @$('.logo-bottom-text').velocity
      opacity: 1
    , @animationTime, @animationAlgo

  showScrollMore: ->
    @$('.scroll-down').velocity
      translateY: 0
      opacity: 1
    , @animationTime / 4, @animationAlgo, => @animateScrollMore()

  animateScrollMore: ->
    @$('.scroll-down-left').velocity rotateZ: 45, 0
    @$('.scroll-down-right').velocity rotateZ: -45, 0
    @scrollSmall()

  scrollSmall: ->
    @$('.scroll-down-left').velocity
      translateY: -@translation
      translateX: -@translation
    , @animationTime, @animationAlgo
    @$('.scroll-down-right').velocity
      translateY: -@translation
      translateX: @translation
    , @animationTime, @animationAlgo, =>
      @scrollLarge()

  scrollLarge: ->
    @$('.scroll-down-right').velocity
      translateY: 0
      translateX: 0
    , @animationTime, @animationAlgo
    @$('.scroll-down-left').velocity
      translateY: 0
      translateX: 0
    , @animationTime, @animationAlgo, =>
      @scrollSmall()


module.exports = HeaderView
