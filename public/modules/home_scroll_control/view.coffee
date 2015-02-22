$ = require '../vendor/jquery.coffee'
_ = require 'underscore'
ScrollControlBase = require "./../scroll/base.coffee"

class HomeScrollControl extends ScrollControlBase

  slides            : ['logo', 'tagline', 'else']
  # Sections we want to fill the height and width of the browser
  fullScreenClasses : ['.logo-section', '.scroll-control', '.map-section']

  onScrollTop: (e) ->
    canScroll = super e
    return if not canScroll
    @trigger 'scroll', from: 'tagline', to: 'logo'

  onScrollAux: (scrollingDown) ->
    if @getSlide() == 'logo' and scrollingDown
      @trigger 'scroll', from: 'logo', to: 'tagline'
    else if @getSlide() == 'tagline' and not scrollingDown
      @trigger 'scroll', from: 'tagline', to: 'logo'
    else if @getSlide() == 'tagline' and scrollingDown
      @fromTaglineToElse()

  fromTaglineToElse: ->
    @firstScroll = on
    @bindScrollTop()
    @freeScrolling on

  freeScrolling: ->
    super()
    $('.scroll-control').attr 'style', ''

  constructor: (options) ->
    super options
    @makeFullScreen()
    @controlScrolling()

module.exports = HomeScrollControl
