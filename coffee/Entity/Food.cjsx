$          = require 'jquery'
_          = require 'lodash'
URL        = require 'url'
App        = require 'ampersand-app'
Collection = require 'ampersand-collection'
Model      = require 'ampersand-model'
Reflux     = require 'reflux'
{ User }   = require './User'

FoodAction = Reflux.createActions [
  'create', 'fetch', 'fetchInit', 'fetchUser',
  'fetchOne', 'like', 'addComment', 'unlike', 'search']

Food = Model.extend
  url: -> App.urlFor "item/#{@itemId}"
  idAttribute: 'itemId'
  props:
    'itemId': 'string'
    'addedDate': 'any'
    'itemName': 'string'
    'photoURL': 'string'
    'caption': 'string'
    'longtitude': 'any'
    'latitude': 'any'
    'userId': 'string'
    'user': 'object'
    'comments': 'any'
    'likes': 'any'

foods = new Collection [], { model: Food }
ajaxQueue = {}

searchContext = null

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
        if ajaxQueue[itemId] is 1
          ajaxQueue[itemId] -= 1
          @trigger { name: 'changed', model: newFood }
        else
          ajaxQueue[itemId] -= 1

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
    { orderBy, limit, startAt, latitude, longtitude } = options
    if (foods.length < (startAt + limit))
      url = App.urlFor 'item', {orderBy, limit, startAt, latitude, longtitude}
      $.ajax
        type: 'GET'
        dataType: 'json'
        crossOrigin: true
        url: url
        success: (data) =>
          if data.length is 0
            @trigger { name: 'empty' }
          else
            newFood = _.map data, (datum) => new Food datum
            foods.add newFood, { merge: true }
            @trigger { name: 'fetched', value: newFood }

  onFetchOne: (itemId) ->
    foods = new Collection [], { model: Food }
    url = App.urlFor "item/#{itemId}"
    $.ajax
      type: 'GET'
      dataType: 'json'
      crossOrigin: true
      url: url
      success: (data) =>
        food = new Food data
        foods.add food
        @trigger {name: 'fetched', value: [food] }

  onFetchInit: (options) ->
    foods = new Collection [], { model: Food }
    @onFetch options

  onLike: (options) ->
    { itemId, key } = options
    url = App.urlFor "item/#{itemId}/like"
    model = foods.get itemId
    model.likes.push
      user:
        displayName: User.name
        providerUserId: User.id
    foods.add model, { merge: true }
    @trigger { name: 'changed', model }
    ajaxQueue[itemId] = (ajaxQueue[itemId] or 0) + 1;
    $.ajax
      type: 'POST'
      crossOrigin: true
      url: url
      success: =>
        @refetch itemId

  onUnlike: (options) ->
    { itemId, key } = options
    url = App.urlFor "item/#{itemId}/like"
    model = foods.get itemId
    model.likes = _.filter model.likes, (like) ->
      like.user.providerUserId isnt User.id
    foods.add model, { merge: true }
    @trigger { name: 'changed', model }
    ajaxQueue[itemId] = (ajaxQueue[itemId] or 0) + 1;
    $.ajax
      type: 'DELETE'
      crossOrigin: true
      url: url
      success: => @refetch itemId

  onAddComment: (options) ->
    { itemId, value } = options
    url = App.urlFor "item/#{itemId}/comment"
    model = foods.get itemId
    model.comments.push
      user:
        displayName: User.name
        providerUserId: User.id
      message: value
    foods.add model, { merge: true }
    @trigger { name: 'changed', model }
    ajaxQueue[itemId] = (ajaxQueue[itemId] or 0) + 1;
    $.ajax
      type: 'POST'
      crossOrigin: true
      dataType: 'json'
      data: { message: value }
      url: url
      success: => @refetch itemId

  onSearch: (options) ->
    foods = new Collection [], { model: Food }
    if (foods.length < (options.startAt + options.limit))
      url = App.urlFor 'item/search', options
      $.ajax
        type: 'GET'
        dataType: 'json'
        crossOrigin: true
        url: url
        success: (data) =>
          newFood = _.map data, (datum) => new Food datum
          foods.add newFood, { merge: true }
          @trigger { name: 'fetched_search', value: newFood }

module.exports = { FoodAction, FoodStore, Food }
