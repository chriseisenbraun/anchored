
_ = require 'underscore'
require 'velocity'
Backbone = require "../vendor/backbone.coffee"

class ProjectsSectionView extends Backbone.View

  el: '.projects-section'

  events:
    'mouseenter .project': 'onImageMouseenter'
    'mouseleave .project': 'onImageMouseleave'
    'click .project'     : 'onClickProject'

  onClickProject: (e) ->
    e.preventDefault()
    app.router.link e

  onImageMouseenter: (e) ->
    target$ = @$(e.currentTarget)
    index = @$('.project').index target$
    color = @$(".project-#{index+1}").css 'background-color'
    @$(".project-#{index+1}").attr 'data-background-color', color
    target$.find('.project-image').velocity 'stop', on
    target$.find('.project-image').velocity
      scale  : 1.2
      rotate : '0.1deg'
    , 1000, 'easeOutQuart'

  onImageMouseleave: (e) ->
    target$ = @$(e.currentTarget)
    index = @$('.project').index target$
    target$.find('.project-image').velocity 'stop', on
    color = @$(".project-#{index+1}").attr 'data-background-color'
    target$.find('.project-image').velocity
      scale  : 1
      rotate : '0.0deg'
    , 2000, 'easeOutQuart'

module.exports = ProjectsSectionView
