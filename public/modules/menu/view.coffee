$ = require '../vendor/jquery.coffee'
require 'velocity'
_ = require 'underscore'
Backbone = require "../vendor/backbone.coffee"

class MenuView extends Backbone.View

  animationAlgo: 'ease-in'
  animationTime: 100

  el: '.menu'

  events:
    'click a': 'onClickMenuItem'

  onClickMenuItem: (e) ->
    @hideMenu()
    @trigger 'itemSelected'
    e.preventDefault()
    app.router.link e

  onMenuButtonChangeEnd: (isShowing) ->
    if isShowing
      @showMenu()
    else
      @hideMenu()

  onMenuButtonChangeStart: (isShowing) ->

  hideMenu: ->
    for i in [0..$('ul li').length]
      last = $('ui li').length - 1
      item$ = $("ul li:eq(#{last - i})")
      _.delay (item$) =>
        @hideMenuItem item$
      , i * (@animationTime/2), item$
    _.delay =>
      @$('.menu-background').velocity
        rotateZ    : -14
        translateY : 50
        translateX : 70
      , @animationTime, @animationAlgo, =>
        @$('.menu-background').velocity
          rotateZ    : 0
          translateY : 0
          translateX : 0
        , @animationTime, @animationAlgo
    , (@animationTime/2) * $('ul li').length
    @trigger 'hidden'

  hideMenuItem: (item$) ->
    item$.velocity
      opacity    : 0
      translateX : 0
    , @animationTime * 2, @animationAlgo

  showMenuItem: (item$) ->
    item$.velocity
      opacity    : 1
      translateX : 50
    , @animationTime * 2, 'ease-out'

  showMenu: ->
    for i in [0..$('ul li').length]
      item$ = $("ul li:eq(#{i})")
      _.delay (item$) =>
        @showMenuItem item$
      , i * (@animationTime/2), item$
    @$('.menu-background').velocity
      rotateZ    : -14
      translateY : 50
      translateX : 70
    , @animationTime, @animationAlgo, =>
      @$('.menu-background').velocity
        rotateZ    : 14
        translateY : -120
        translateX : 380
      , @animationTime, @animationAlgo
    @trigger 'shown'

module.exports = MenuView
