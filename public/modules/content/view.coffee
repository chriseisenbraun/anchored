require 'velocity'
Backbone = require "../vendor/backbone.coffee"
_ = require 'underscore'

class ContentView extends Backbone.View

  el: '.content'

  animationTime: 200

  onMenuShown: ->
    _.delay =>
      @$el.velocity
        translateX: 100
      , @animationTime, 'ease-in'
    , 150

  onMenuHidden: ->
    @$el.velocity
      translateX: 0
    , @animationTime, 'ease-out', =>
      #@$(document).scrollTop 0
      @$el.attr 'style', ''

  loadContent: (content$) ->
    @$el.html content$.html()
    @trigger 'contentLoaded'

module.exports = ContentView
