$ = require '../vendor/jquery.coffee'
_ = require 'underscore'
Backbone = require "../vendor/backbone.coffee"

class ScrollControlBase

  getSlide: -> @slides[@currentSlide]

  constructor: (@sections) ->
    _.extend @, Backbone.Events
    @currentSlide = 0
    _(@).bindAll 'onMouseWheel', 'onScrollTop'

  makeFullScreen: ->
    @onResizeThrottled = _.throttle @onResize, 100
    $(window).resize => @onResizeThrottled()
    @onResize()

  onResize: ->
    @height = $(window).height()
    $(sel).height @height for sel in @fullScreenClasses
    return

  controlScrolling: ->
    css =
      'height'  : '100%'
      'overflow': 'hidden'
    for key, value of css
      for elem in ['html', 'body']
        $(elem).css key, value
    if document.addEventListener
      #IE9, Chrome, Safari, Opera
      document.addEventListener 'mousewheel', @onMouseWheel, off
      #Firefox
      document.addEventListener 'wheel', @onMouseWheel, off
    else
      #IE 6/7/8
      document.attachEvent 'onmousewheel', @onMouseWheel
    return

  bindScrollTop: ->
    console.log 'binding scroll event'
    @lastScroll = $(document).scrollTop()
    $(document).on 'scroll', @onScrollTop

  unbindScrollTop: -> $(document).off 'scroll'

  clean: ->
    @unbindScrollTop()
    @freeScrolling off

  onScrollTop: (e) ->
    currentScroll = $(document).scrollTop()
    if currentScroll > 0 and @firstScroll == on
      @firstScroll = off
      $(document).scrollTop 0
      @lastScroll = 0
      return off
    if currentScroll > 0 or currentScroll >= @lastScroll
      @lastScroll = $(document).scrollTop()
      return off
    @currentSlide = 0
    @controlScrolling()
    on

  freeScrolling: (scrollUp) ->
    for elem in ['html', 'body']
      $(elem).attr 'style', ''
    if scrollUp
      _.defer -> $(document).scrollTop 0
    if document.addEventListener
      #IE9, Chrome, Safari, Oper
      document.removeEventListener 'mousewheel', @onMouseWheel, off
      #Firefox
      document.removeEventListener 'wheel', @onMouseWheel, off
    else
      #IE 6/7/8
      document.detachEvent 'onmousewheel', @onMouseWheel
    return


  ###*
  Detecting mousewheel scrolling
  http://blogs.sitepointstatic.com/examples/tech/mouse-wheel/index.html
  http://www.sitepoint.com/html5-javascript-mouse-wheel/
  ###
  onMouseWheel: (e) ->
    return if @mouseWheelLocked == on
    # cross-browser wheel delta
    e = window.event or e
    delta = Math.max(-1, Math.min(1, \
                    (e.wheelDelta or -e.deltaY or -e.detail)))
    if delta < 0
      @onScrollDown()
    #scrolling up?
    else
      @onScrollUp()
    off

  onScrollDown: ->
    return if @scrollLock == on or @currentSlide > 1
    @scrollLock = on
    @onScrollAux on
    @currentSlide++

  onScrollUp: ->
    return if @scrollLock == on or @currentSlide == 0
    @scrollLock = on
    @onScrollAux off
    @currentSlide--

  onScrollFinished: ->
    @scrollLock = off

module.exports = ScrollControlBase
