_ = require 'underscore'
require 'velocity'
Backbone = require "../vendor/backbone.coffee"

class HomeMapSectionView extends Backbone.View

  animationTime: 800

  el: '.map-section'

  events:
    'click .btn-map-view' : 'onClickMapView'

  initialize: (@sections) ->

  onClickMapView: ->
    @$('.logo').velocity
      translateX : '-50%'
      translateY : '-50%'
      scale      : 0.5
    , 0
    @$('.logo').velocity
      translateX : '-50%'
      translateY : '-50%'
      opacity    : 0
      scale      : 0.1
    , @animationTime / 2, 'easeOutBack'
    @$('.map-address').velocity
      opacity    : 0
    , @animationTime / 2, 'easeOutBack'
    @$('.btn-map-directions').velocity
      translateX : -55
    , @animationTime / 2, 'easeOutBack'
    @$('.btn-map-view').velocity
      opacity    : 0
      scale      : 0.2
      translateY : -20
    , @animationTime / 2, 'easeOutBack'
    @$('.btn-map-directions').velocity
      backgroundColor      : '#000000'
      backgroundColorAlpha : 0
    , 0
    @$('.btn-map-directions').velocity
      backgroundColor      : '#000000'
      backgroundColorAlpha : 1
      color                : '#ffffff'
      borderColor          : '#000000'
    , @animationTime / 2, 'easeOutQuart', =>
      @$('.map-dark-overlay').velocity
        opacity: 0
      , @animationTime, 'easeOutQuart'
      @$('.map-marker').velocity opacity: 0, 0
      @$('.map-marker').velocity
        opacity    : 1
      , @animationTime, 'easeInQuart', =>
        @animateMarker()

  animateMarker: ->
    @$('.map-marker').velocity
      translateY : 10
    , @animationTime, 'linear', =>
      @$('.map-marker').velocity
        translateY : 0
      , @animationTime, 'linear', =>
        @animateMarker()
    


module.exports = HomeMapSectionView
