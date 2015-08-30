App = require 'ampersand-app'
Reflux = require 'reflux'
{ FoodAction } = require './Food'

FilterAction = Reflux.createActions ['change']

Filter =
  Latest:
    heading: () -> "Recent Items"
    init: () ->
      FoodAction.fetchInit { orderBy: 'date', startAt:0, limit: 3 }
    fn: (startAt) ->
      FoodAction.fetchInit { orderBy: 'date', startAt, limit: 3 }
  Nearby:
    heading: () -> "Food Nearby"
    init: () ->
      FoodAction.fetchInit { orderBy: 'location', startAt:0, limit: 3 }
    fn: (startAt) ->
      FoodAction.fetch { orderBy: 'location', startAt, limit: 3 }

FilterStore = Reflux.createStore
  listenables: FilterAction
  onChange: (event) -> @trigger event

module.exports = {FilterAction, FilterStore, Filter}
