$          = require 'jquery'
_          = require 'lodash'
URL        = require 'url'
App        = require 'ampersand-app'
Collection = require 'ampersand-rest-collection'
Model      = require 'ampersand-model'
Reflux     = require 'reflux'
{ User }   = require './User'

FoodAction = Reflux.createActions ['create', 'fetch', 'fetchInit',
  'fetchUser', 'like', 'addComment', 'unlike']

Food = Model.extend
  url: -> App.urlFor 'item'
  idAttribute: 'itemId'
  props:
    'itemId': 'string'
    'addedDate': 'any'
    'itemName': 'string'
    'photoURL': 'string'
    'caption': 'string'
    'longitude': 'any'
    'longtitude': 'any'
    'latitude': 'any'
    'userId': 'string'
    'user': 'object'
    'comments': 'any'
    'likes': 'any'
  derived:
    name: ->
      deps: ['itemName']
      fn: -> @itemName

foods = new Collection [], { model: Food }

FoodStore = Reflux.createStore
  listenables: FoodAction

  refetch: (itemId) ->
    url = App.urlFor "item/#{itemId}"
    $.ajax
      type: 'GET'
      dataType: 'json'
      crossOrigin: true
      url: url
      success: (data) =>
        newFood = new Food data
        foods.add newFood, { merge: true }
        @trigger { name: 'changed', model: newFood }

  onCreate: (options) ->
    $.ajax
      type: 'POST'
      dataType: 'json'
      data: JSON.stringify options
      crossOrigin: true
      url: App.urlFor 'item'
      success: (data) =>
        newFood = new Food data
        foods.add newFood, { merge: true }
        @trigger { name: 'created', value: newFood }

  onFetch: (options) ->
    { orderBy, limit, startAt } = options
    if (foods.length < (startAt + limit))
      { latitude, longitude } = User
      url = App.urlFor 'item', {orderBy, limit, startAt, latitude, longitude}
      $.ajax
        type: 'GET'
        dataType: 'json'
        crossOrigin: true
        url: url
        success: (data) =>
          newFood = _.map data, (datum) => new Food datum
          foods.add newFood, { merge: true }
          @trigger { name: 'fetched', value: newFood }

  onFetchInit: (options) ->
    foods = new Collection [], { model: Food }
    @onFetch options

  onFetchUser: (userId) ->
    base = App.urlFor 'users'
    url = URL.resolve base, '/users/#{userId}/recent'
    $.ajax
      type: 'GET'
      dataType: 'json'
      crossOrigin: true
      url: url
      success: (data) =>
        newFood = _.map data.data, (datum) => new Food datum
        foods.add newFood
        @trigger { name: 'fetched', value: newFood }

  onLike: (options) ->
    { itemId, key } = options
    url = App.urlFor "item/#{itemId}/like"
    $.ajax
      type: 'POST'
      crossOrigin: true
      url: url
      success: => @refetch itemId

  onUnlike: (options) ->
    { itemId, key } = options
    url = App.urlFor "item/#{itemId}/like"
    $.ajax
      type: 'DELETE'
      crossOrigin: true
      url: url
      success: => @refetch itemId

  onAddComment: (options) ->
    { itemId, value } = options
    url = App.urlFor "item/#{itemId}/comment"
    $.ajax
      type: 'POST'
      crossOrigin: true
      dataType: 'json'
      data: { message: value }
      url: url
      success: => @refetch itemId

module.exports = { FoodAction, FoodStore, Food }
