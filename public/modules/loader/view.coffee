require 'velocity'
Backbone = require "../vendor/backbone.coffee"
_ = require 'underscore'

class LoaderView extends Backbone.View

  el: '.loader'

  animationTime: 400

  initialize: ->
    height = $(window).height()
    @blockQueue = @onPageLoadedQueued = off
    @$('.loader-left').css 'border-width': "0 0 #{height}px 300px"
    @$('.loader-right').css 'border-width': "#{height}px 0 0 300px"

  onPageSelected: ->
    return if @blockQueue == on
    @blockQueue = on
    @$('.loader-left').velocity
      scaleX: 0
    , 0, 'ease-in'
    @$el.velocity
      translateX: '100%'
    , 0, 'ease-in'
    @$('.loader-left').velocity
      scaleX: 2
    , @animationTime / 2, 'ease-in', =>
      @$('.loader-left').velocity
        scaleX: 1
      , @animationTime / 2, 'ease-in'
    , @animationTime * 4 / 3
    _.delay =>
      @$el.velocity
        translateX: '0px'
      , @animationTime, 'ease-in', =>
        @blockQueue = on
        @trigger 'showFinished'
        @processQueue()
    , @animationTime
    @animatingCircle = on
    @animateCircle()

  isQueueBlocked: -> @blockQueue

  processQueue: ->
    @blockQueue = off
    if @onPageLoadedQueued == on
      @onPageLoadedQueued = off
      _.delay =>
        @onPageLoaded()
      , 1000

  animateCircle: ->
    return if @animatingCircle == off
    @$('.loader-circle').velocity
      scale: 0.75
    , 2000, =>
      @$('.loader-circle').velocity
        scale: 1
      , 2000, =>
        @animateCircle()

  onPageLoaded: ->
    if @blockQueue == on
      @onPageLoadedQueued = on
      return
    translate = $(window).width() + 300
    @$el.velocity
      translateX: "-#{translate}px"
    , @animationTime, 'ease-out'
    @$('.loader-right').velocity
      scaleX: 2
    , @animationTime / 2, 'ease-out', =>
      @$('.loader-right').velocity
        scaleX: 0
      , @animationTime / 2, 'ease-out', =>
        @animatingCircle = off

module.exports = LoaderView
