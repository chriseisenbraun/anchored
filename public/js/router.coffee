Backbone = require 'backbone'
_ = require 'underscore'

class Router extends Backbone.Router

  routes:
    ''         : 'home'
    'about'    : 'about'
    'projects' : 'projects'
    'contact'  : 'contact'

  home     : -> console.log 'home'
  about    : -> console.log 'about'
  projects : -> console.log 'projects'
  contact  : -> console.log 'contact'

  navigate: (fragment, options) ->
    newFragment = fragment
    if fragment[0] == '/'
      newFragment = newFragment.slice 1
    currentFragment = Backbone.history.getFragment()
    return if currentFragment == newFragment
    super fragment, options
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
    @loader.onPageLoaded()

  onShowFinished: ->
    @showFinished = on
    @attemptRenderContent()

  initialize: (@loader, @content) ->
    @loader.on 'showFinished', @onShowFinished, @
    @content.on 'contentLoaded', @onContentLoaded, @
    _(@).bindAll 'onRouteFetched'

module.exports = Router
