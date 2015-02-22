# Lib
$ = require 'jquery'
_ = require 'underscore'
Backbone = require '../vendor/backbone.coffee'

# Internal
Router = require '../router/view.coffee'

window.app = {}

$ ->
  app.router = new Router
  Backbone.history.start pushState: on
