App = require 'ampersand-app'
{ FoodAction } = require './Food'

module.exports =
  MyCollection: (startAt) ->

  Nearby: (startAt) ->
    FoodAction.fetch
      orderBy: 'location'
      startAt: startAt
      limit: 3
