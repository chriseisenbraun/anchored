_ = require 'underscore'
require 'velocity'
Backbone = require "../vendor/backbone.coffee"

class HomeView extends Backbone.View

  el: 'project-section'

  initialize: ->
    a = 1

module.extends = HomeView
