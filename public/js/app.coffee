# Lib
Backbone = require './backbone.coffee'
$ = require 'jquery'
_ = require 'underscore'
picture = require 'picturefill', @

# Internal
Router = require './router.coffee'
MenuView = require './menu.coffee'
MenuButtonView = require './menu_button.coffee'
ContentView = require './content.coffee'
LoaderView = require './loader.coffee'
HeaderView = require './header.coffee'

window.app = {}

$ ->
  Backbone.history.start pushState: on
  loader = new LoaderView
  content = new ContentView
  app.router = new Router loader, content
  menuButton = new MenuButtonView
  menuButton.on 'interactionStart', (isShowing) ->
    app.menu.onMenuButtonChangeStart isShowing
  menuButton.on 'interactionEnd', (isShowing) ->
    app.menu.onMenuButtonChangeEnd isShowing
  app.menu = new MenuView
  app.header = new HeaderView
  app.menu.on 'itemSelected', ->
    menuButton.hamburgerMode on
  app.menu.on 'hidden', ->
    content.onMenuHidden()
  app.menu.on 'shown', ->
    content.onMenuShown()
