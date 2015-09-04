App = require 'ampersand-app'
Reflux = require 'reflux'
{ UserAction, UserStore, User } = require './User'
{ FoodAction } = require './Food'

FilterAction = Reflux.createActions ['change', 'revert']

Latest = ->
  heading: -> "Recent Items"
  init: ->
    FoodAction.fetchInit { orderBy: 'date', startAt:0, limit: 3 }
  fn: (startAt) ->
    FoodAction.fetch { orderBy: 'date', startAt, limit: 3 }

Nearby = ->
  heading: () -> "Food Nearby"
  init: () ->
    UserAction.watch()
    UserStore.listen (e) ->
      if (e is 'location_success') or (e is 'location_failure')
        FoodAction.fetchInit
          orderBy: 'location'
          startAt:0
          limit: 3
          latitude: User.latitude
          longtitude: User.longitude

  fn: (startAt) ->
    FoodAction.fetch
      orderBy: 'location'
      startAt: startAt
      limit: 3
      latitude: User.latitude
      longtitude: User.longitude


Search = (keyword) ->
  heading: ->
    if keyword == ""
      "Please enter a keyword..."
    else
      "Results for #{keyword}..."
  init: ->
    FoodAction.search { keyword, orderBy: 'date', startAt:0, limit: 100 }

Single = (itemId) ->
  heading: -> ""
  init: -> FoodAction.fetchOne itemId

mapping =
  'latest': Latest,
  'recent': Latest,
  'nearby': Nearby,
  'search': Search,
  'single': Single

current = null

FilterStore = Reflux.createStore
  listenables: FilterAction

  onChange: (options) ->
    filter = mapping[options.name]
    current = filter(options.arg) unless (options.name is 'search')
    if filter then @trigger filter(options.arg)

  onRevert: -> @trigger current

module.exports = { FilterAction, FilterStore }
