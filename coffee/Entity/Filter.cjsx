App = require 'ampersand-app'
{ FoodAction } = require './Food'

module.exports =
  Recent:
    heading: () -> "Recent Items"
    fn: (startAt) ->
      FoodAction.fetch { orderBy: 'date', startAt, limit: 3 }

  Nearby:
    heading: () -> "Food Nearby"
    fn: (startAt) ->
      FoodAction.fetch { orderBy: 'location', startAt, limit: 3 }
