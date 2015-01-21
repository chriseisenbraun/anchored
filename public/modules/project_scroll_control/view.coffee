# Libraries
$                 = require 'jquery'

# Internal
ScrollControlBase = require './../scroll/base.coffee'
HitPoint          = require '../scroll/hit_point.coffee'
HitRange          = require '../scroll/hit_range.coffee'

class ProjectScrollControl extends ScrollControlBase

  firstScroll       : on
  lastScroll        : 0
  slides            : []
  fullScreenClasses : []
  hitPoints         : [
    new HitPoint('banner-start', '.project-header-banner', 'top', 0)
    new HitPoint('banner-end', '.project-header-banner', 'bottom', -100)
    new HitPoint('mac-start', '.project-header-mac', 'top', 0)
  ]
  hitRanges         : [
    new HitRange('banner', ProjectScrollControl::hitPoints[0], \
                           ProjectScrollControl::hitPoints[1])
  ]

  constructor: (sections) ->
    @attatchHits()
    super sections
    @bindScrollTop()

  attatchHits: ->
    p.attach() for p in @hitPoints
    r.attach() for r in @hitRanges

  onScrollAux: (scrollingDown) -> @onScrollTop()

  onScrollTop: ->
    currentScroll = $(document).scrollTop()
    return if currentScroll is @lastScroll
    for hitPoint in @hitPoints
      if hitPoint.contains @lastScroll, currentScroll
        @trigger 'hitPoint', hitPoint
    for hitRange in @hitRanges
      if hitRange.contains currentScroll
        @trigger 'hitRange', hitRange
    @lastScroll = currentScroll

module.exports = ProjectScrollControl
