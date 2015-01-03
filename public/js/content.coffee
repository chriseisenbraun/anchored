require 'velocity'
Backbone = require './backbone.coffee'
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
    , @animationTime, 'ease-out'

  loadContent: (content$) ->
    @$el.html content$.html()
    @trigger 'contentLoaded'

module.exports = ContentView
