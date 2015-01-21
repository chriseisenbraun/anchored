# Lib
_ = require 'underscore'
$ = require 'jquery'
Backbone = require "../vendor/backbone.coffee"

# Internal
MenuView = require '../menu/view.coffee'
MenuButtonView = require '../menu_button/view.coffee'
ContentView = require '../content/view.coffee'
LoaderView = require '../loader/view.coffee'

# Sections

# Home
HomeWelcomeSectionView = require '../home_welcome/view.coffee'
HomeScrollControl = require '../home_scroll_control/view.coffee'
HomeMapSectionView = require '../home_map/view.coffee'

# Projects
ProjectsSectionView = require '../projects/view.coffee'

# Project
ProjectSectionView = require '../project/view.coffee'
ProjectScrollControl = require '../project_scroll_control/view.coffee'

# Gl
GLView = require '../gl/view.coffee'

class Router extends Backbone.Router

  routes:
    ''         : 'home'
    'about'    : 'about'
    'projects' : 'projects'
    'project'  : 'project'
    'contact'  : 'contact'
    'gl'       : 'gl'

  gl: ->
    gl = new GLView
    gl.animate()

  home: ->
    @sections.welcome = new HomeWelcomeSectionView @scrollControl
    @sections.welcome.on 'scrollFinished', => @scrollControl.onScrollFinished()
    @sections.map = new HomeMapSectionView @scrollControl
    @initializeHomeScrollControl()

  initializeHomeScrollControl: ->
    @scrollControl = new HomeScrollControl @sections
    @scrollControl.on 'scroll', (info) =>
      if info.from == 'logo' and info.to == 'tagline'
        @sections.welcome.fromLogoToTagline()
      if info.from == 'tagline' and info.to == 'logo'
        @sections.welcome.fromTaglineToLogo()

  projects: ->
    @sections.projects = new ProjectsSectionView @scrollControl

  project: ->
    @sections.project = new ProjectSectionView
    @initializeProjectScrollControl()

  initializeProjectScrollControl: ->
    @scrollControl = new ProjectScrollControl @sections
    @scrollControl.on 'hitPoint', (hitPoint) =>
      if hitPoint.name == 'banner-start'
        @sections.project.onScrollBannerStart hitPoint
      if hitPoint.name == 'banner-end'
        @sections.project.onScrollBannerEnd hitPoint
      if hitPoint.name == 'mac-start'
        @sections.project.onScrollMacStart hitPoint
    @scrollControl.on 'hitRange', (hitRange) =>
      if hitRange.name == 'banner'
        @sections.project.onScrollBannerIn hitRange

  about: ->
    console.log 'about'

  contact: ->
    console.log 'contact'

  navigate: (fragment, options) ->
    @scrollControl?.clean()
    newFragment = fragment
    if fragment[0] == '/'
      newFragment = newFragment.slice 1
    currentFragment = Backbone.history.getFragment()
    return if currentFragment == newFragment
    @historyOptions.fragment = fragment
    @historyOptions.options = options
    $.ajax
      url: fragment
    .done @onRouteFetched
    @loader.onPageSelected fragment

  onRouteFetched: (data) ->
    @routeFetched = on
    for elem in $(data)
      elem$ = $(elem)
      if elem$.hasClass 'content'
        @elem$ = elem$
        @attemptRenderContent()
        break

  attemptRenderContent: ->
    if @showFinished == on and @routeFetched == on
      @showFinished = @routeFetched = off
      @content.loadContent @elem$
      @elem$ = undefined

  onContentLoaded: ->
    Backbone.Router::navigate.apply @, \
          [@historyOptions.fragment, @historyOptions.options]
    @loader.onPageLoaded()

  onShowFinished: ->
    @showFinished = on
    @attemptRenderContent()

  initializeMenu: ->
    @menuButton = new MenuButtonView
    @menuButton.on 'interactionStart', (isShowing) =>
      @menu.onMenuButtonChangeStart isShowing
    @menuButton.on 'interactionEnd', (isShowing) =>
      @menu.onMenuButtonChangeEnd isShowing
    @menu = new MenuView
    @menu.on 'itemSelected', => @menuButton.hamburgerMode on
    @menu.on 'hidden', => @content.onMenuHidden()
    @menu.on 'shown', => @content.onMenuShown()

  initialize: ->
    @initializeMenu()
    @loader = new LoaderView
    @content = new ContentView
    @loader.on 'showFinished', @onShowFinished, @
    @content.on 'contentLoaded', @onContentLoaded, @
    @sections = {}
    @historyOptions = {}
    _(@).bindAll 'onRouteFetched'

module.exports = Router
