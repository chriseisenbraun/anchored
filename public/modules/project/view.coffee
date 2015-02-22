_ = require 'underscore'
require 'velocity'
Backbone = require "../vendor/backbone.coffee"

class ProjectView extends Backbone.View

  el               : '.project-section'
  percentageFade   : 0.30
  headerTranslateY : -250
       
  initialize: ->
    @projectHeaderHeight = @$('.project-header').height()
    @macImageHeight = @$('.project-header-mac-content img').height()
    @macImageContHeight = @$('.project-header-mac-content').height()

  onScrollBannerStart: (hitPoint) ->
    @$('.project-header-banner-inner').css opacity: 1
    @$('.project-header-mac').css opacity: 1

  onScrollBannerEnd: (hitPoint) ->
    @$('.project-header-mac').css opacity: 0
    @$('.project-header-banner-inner').css opacity: 0

  onScrollBannerIn: (hitRange) ->
    progress = hitRange.progress()
    @$('.project-header-banner-inner').css opacity: progress
    headerTransCurrent = @headerTranslateY * (1-progress)
    @$('.project-header').height @projectHeaderHeight + headerTransCurrent
    macImageTransCurrent = @macImageHeight * (1-progress) - \
                           @macImageContHeight * (1-progress)
    @$('.project-header-mac-content img').css
      transform: "translateY(-#{macImageTransCurrent}px)"
    if progress < @percentageFade
      macProgress = progress / @percentageFade
    else
      macProgress = 1
    @$('.project-header-mac').css opacity: macProgress

  onScrollMacStart: (hitPoint) ->
    console.log 'mac start'

module.exports = ProjectView
