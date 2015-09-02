App = require 'ampersand-app'
Reflux = require 'reflux'
{ FoodAction } = require './Food'

FilterAction = Reflux.createActions ['change', 'revert']

Latest = ->
  heading: -> "Recent Items"
  init: ->
    FoodAction.fetchInit { orderBy: 'date', startAt:0, limit: 3 }
  fn: (startAt) ->
    FoodAction.fetchInit { orderBy: 'date', startAt, limit: 3 }

Nearby = ->
  heading: () -> "Food Nearby"
  init: () ->
    FoodAction.fetchInit { orderBy: 'location', startAt:0, limit: 3 }
  fn: (startAt) ->
    FoodAction.fetch { orderBy: 'location', startAt, limit: 3 }

Search = (keyword) ->
  heading: ->
    if keyword == ""
      "Please enter a keyword..."
    else
      "Results for #{keyword}..."
  init: ->
    FoodAction.search { keyword, orderBy: 'date', startAt:0, limit: 100 }

mapping = { 'latest': Latest, 'recent': Latest, 'nearby': Nearby, 'search':Search }
current = null

FilterStore = Reflux.createStore
  listenables: FilterAction

  onChange: (options) ->
    filter = mapping[options.name]
    current = filter(options.arg) unless (options.name is 'search')
    if filter then @trigger filter(options.arg)

  onRevert: -> @trigger current

module.exports = { FilterAction, FilterStore }
