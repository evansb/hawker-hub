$          = require 'jquery'
_          = require 'lodash'
URL        = require 'url'
App        = require 'ampersand-app'
Collection = require 'ampersand-rest-collection'
Model      = require 'ampersand-model'
Reflux     = require 'reflux'

UserAction = Reflux.createActions ['status', 'login', 'logout']

User = { isLoggedIn: false }

onSuccessLoc = (pos) ->
  User.latitude = pos.coords.latitude
  User.longitude = pos.coords.longitude

onErrorLoc = ->

locOptions =
  enableHighAccuracy: false
  timeout: 4000
  maximumAge: 30000

UserStore = Reflux.createStore
  listenables: UserAction

  watchUserPosition: ->
    if (typeof navigator isnt 'undefined')
      navigator.geolocation.watchPosition(onSuccessLoc, onErrorLoc, locOptions)

  fetchUserInfo: ->
    @watchUserPosition()
    FB.api '/me/?fields=id,name,picture', (response) =>
      User.id = response.id
      User.name = response.name
      User.profilePicture = response.picture.data.url
      @trigger { name: 'status', value: 'connected' }

  onLogin: ->
    callback = (response) =>
      if (response.status is 'connected')
        url = App.urlFor 'users/login'
        $.ajax
          type: 'GET'
          url: url
          success: => @fetchUserInfo()
    FB.login callback, { scope: 'publish_actions,user_friends' }

  onLogout: () ->
    FB.logout()
    url = App.urlFor 'users/logout'
    $.ajax
      type: 'GET'
      url: url
      success: (data) =>
        @trigger { name: 'status', value: 'logged_out' }

  onStatus: ->
    FB.getLoginStatus (response) =>
      User.isLoggedIn = response.status is 'connected'
      if (User.isLoggedIn) then @fetchUserInfo() else @onLogin()

module.exports = { UserAction, UserStore, User }
