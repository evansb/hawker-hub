$          = require 'jquery'
_          = require 'lodash'
URL        = require 'url'
App        = require 'ampersand-app'
Reflux     = require 'reflux'
{Food}     = require './Food'

SingleFoodAction = Reflux.createActions ['fetch', 'like', 'unlike']

food = null

SingleFoodStore = Reflux.createStore
  listenables: SingleFoodAction

  refetch: (itemId) ->
    url = App.urlFor "item/#{itemId}"
    $.ajax
      type: 'GET'
      dataType: 'json'
      crossOrigin: true
      url: url
      success: (data) =>
        food = new Food data
        @trigger food

  onFetch: (id) ->
    url = App.urlFor 'item' + '/' + id
    $.ajax
      type: 'GET'
      dataType: 'json'
      crossOrigin: true
      url: url
      success: (data) =>
        food = new Food data
        @trigger food

  onLike: (itemId) ->
    if (food && (itemId is food.itemId))
      url = App.urlFor "item/#{itemId}/like"
      $.ajax
        type: 'POST'
        crossOrigin: true
        url: url
        success: => @refetch itemId

  onUnlike: (options) ->
    if (food && (itemId is food.itemId))
      { itemId, key } = options
      url = App.urlFor "item/#{itemId}/like"
      $.ajax
        type: 'DELETE'
        crossOrigin: true
        url: url
        success: => @refetch itemId


module.exports = { SingleFoodAction, SingleFoodStore }
