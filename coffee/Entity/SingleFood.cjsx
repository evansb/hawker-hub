$          = require 'jquery'
_          = require 'lodash'
URL        = require 'url'
App        = require 'ampersand-app'
Reflux     = require 'reflux'
{Food}     = require './Food'

SingleFoodAction = Reflux.createActions ['fetch']

food = null

SingleFoodStore = Reflux.createStore
  listenables: SingleFoodAction

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

module.exports = { SingleFoodAction, SingleFoodStore }
