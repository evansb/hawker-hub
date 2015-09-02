App = require 'ampersand-app'
Reflux = require 'reflux'
{ FoodAction } = require './Food'

FilterAction = Reflux.createActions ['change']

Latest =
  heading: () -> "Recent Items"
  init: () ->
    FoodAction.fetchInit { orderBy: 'date', startAt:0, limit: 3 }
  fn: (startAt) ->
    FoodAction.fetchInit { orderBy: 'date', startAt, limit: 3 }

Nearby =
  heading: () -> "Food Nearby"
  init: () ->
    FoodAction.fetchInit { orderBy: 'location', startAt:0, limit: 3 }
  fn: (startAt) ->
    FoodAction.fetch { orderBy: 'location', startAt, limit: 3 }

mapping = { 'latest': Latest, 'recent': Latest, 'nearby': Nearby }

FilterStore = Reflux.createStore
  listenables: FilterAction

  onChange: (name) ->
    filter = mapping[name]
    if filter then @trigger filter

module.exports = { FilterAction, FilterStore }
