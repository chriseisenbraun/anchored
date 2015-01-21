_ = require 'underscore'
require 'velocity'
Backbone = require "../vendor/backbone.coffee"

class HomeWelcomeSectionView extends Backbone.View

  animationTime: 500
  animationAlgo: 'easeOutQuart'
  translation  : 2

  el: '.logo-section'

  initialize: ->
    @$('.tagline').velocity translateY: 100, opacity: 0, 0
    @animateLogoInitial()

  animateLogoInitial: ->
    @$('.scroll-down').velocity translateY: 20, opacity: 0, 0
    @$('.logo').velocity translateY: -50, scale: 1.5, opacity: 0, 0
    @$('.logo-extra').velocity scaleY: 1, 0
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
    delay = 400
    first$ = @$('.scroll-down-arrow.first')
    second$ = @$('.scroll-down-arrow.second')
    first$.velocity opacity: 1, delay/2, 'linear', ->
      first$.velocity opacity: 0, delay*2, 'linear'
    _.delay =>
      second$.velocity opacity: 1, delay/2, 'linear', =>
        second$.velocity opacity: 0, delay*2, 'linear', =>
          _.delay =>
            @animateScrollMore()
          , 500
    , 300

  fromTaglineToLogo: ->
    @$('.tagline').velocity 'stop'
    @$('.tagline').velocity
      translateY: 100
      opacity   : 0
    , @animationTime / 2, @animationAlgo, =>
      @$('.logo').velocity 'stop'
      @$('.logo').velocity
        scale: 1
      , @animationTime / 1.5, @animationAlgo, =>
        @trigger 'scrollFinished'
      @$('.scroll-down').velocity 'stop'
      @$('.scroll-down').velocity
        translateY: 0
        opacity   : 1
      , @animationTime, @animationAlgo
      @$('.logo-dark-overlay').velocity 'stop'
      @$('.logo-dark-overlay').velocity
        opacity: 0.3
      , @animationTime / 2, @animationAlgo

  fromLogoToTagline: ->
    @$('.logo').velocity 'stop'
    @$('.logo').velocity
      scale     : 0.5
      translateY: 60
    , @animationTime, @animationAlgo
    @$('.scroll-down').velocity 'stop'
    @$('.scroll-down').velocity
      translateY: 20
      opacity   : 0
    , @animationTime / 2, @animationAlgo
    @$('.tagline').velocity 'stop'
    @$('.tagline').velocity
      translateY: 0
      opacity   : 1
    , @animationTime, @animationAlgo, =>
      @trigger 'scrollFinished'
    @$('.logo-dark-overlay').velocity 'stop'
    @$('.logo-dark-overlay').velocity
      opacity: 0.7
    , @animationTime, @animationAlgo


module.exports = HomeWelcomeSectionView
