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
# GLView = require '../gl/view.coffee'
# GLThreeView = require '../glthree/view.coffee'

class Router extends Backbone.Router

  routes:
    ''                                 : 'home'
    'about/'                           : 'about'
    'about'                            : 'about'
    'projects/'                        : 'projects'
    'projects'                         : 'projects'
    'projects/:year/:month/:day/:slug' : 'project'
    'contact/'                         : 'contact'
    'contact'                          : 'contact'
    'gl/'                              : 'gl'
    'gl'                               : 'gl'
    'glthree/'                         : 'glThree'
    'glthree'                          : 'glThree'

  gl: ->
    # gl = new GLThreeView
    # gl.animate()

  glThree: ->
    # gl = new GLView
    # gl.animate()

  home: ->
    @beforeRoute =>
      @sections.welcome = new HomeWelcomeSectionView @scrollControl
      @sections.welcome.on 'scrollFinished', => @scrollControl.onScrollFinished()
      @sections.map = new HomeMapSectionView @scrollControl
      @initializeHomeScrollControl()
      # gl = new GLView
      # gl.animate()

  initializeHomeScrollControl: ->
    @scrollControl = new HomeScrollControl @sections
    @scrollControl.on 'scroll', (info) =>
      if info.from == 'logo' and info.to == 'tagline'
        @sections.welcome.fromLogoToTagline()
      if info.from == 'tagline' and info.to == 'logo'
        @sections.welcome.fromTaglineToLogo()

  projects: ->
    @beforeRoute =>
      @sections.projects = new ProjectsSectionView @scrollControl

  project: ->
    @beforeRoute =>
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
    @beforeRoute =>
      console.log 'about'

  contact: ->
    @beforeRoute =>
      console.log 'contact'

  beforeRoute: (callback) ->
    @scrollControl?.clean()
    if @firstInit
      @firstInit = off
      return callback()
    fragment = Backbone.history.getFragment()
    @historyOptions.fragment = fragment
    @historyOptions.callback = callback
    $.ajax
      url: "/#{fragment}"
    .done @onRouteFetched
    @loader.onPageSelected fragment

  link: (e) ->
    link = $(e.currentTarget).attr 'href'
    # some browser automatically replace / with the hostname...
    # we dont want that for routing...
    unless history.pushState
      http = location.protocol
      slashes = http.concat "//"
      host = slashes.concat window.location.hostname
      link = link.replace host, ''  if link
      link = link.replace /^\/|\/$/g, ''
    @navigate link, trigger: on

  navigate: (fragment, options) ->
    newFragment = fragment
    if fragment[0] == '/'
      newFragment = newFragment.slice 1
    currentFragment = Backbone.history.getFragment()
    return if currentFragment == newFragment
    #@historyOptions.fragment = fragment
    #@historyOptions.options = options
    super fragment, options

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
    #Backbone.Router::navigate.apply @, \
    #      [@historyOptions.fragment, @historyOptions.options]
    @loader.onPageLoaded()
    @historyOptions.callback()

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
    @firstInit = on
    @initializeMenu()
    @loader = new LoaderView
    @content = new ContentView
    @loader.on 'showFinished', @onShowFinished, @
    @content.on 'contentLoaded', @onContentLoaded, @
    @sections = {}
    @historyOptions = {}
    _(@).bindAll 'onRouteFetched'

module.exports = Router
