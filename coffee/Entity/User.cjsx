$          = require 'jquery'
_          = require 'lodash'
URL        = require 'url'
App        = require 'ampersand-app'
Collection = require 'ampersand-rest-collection'
Model      = require 'ampersand-model'
Reflux     = require 'reflux'

# Actions pertaining to user
UserAction = Reflux.createActions [
  'status',   # Check user login status
  'login',    # Login to Facebook && HawkerHub
  'logout',   # Logout from HawkerHub
  'watch',    # Start watching user locations
  'stopWatch' # Stop watching user locations
]

# The singleton user model
User =
  name: null
  isLoggedIn: false
  latitude: null
  longitude: null

# User Store as event hub
UserStore = Reflux.createStore
  listenables: UserAction

  onWatch: ->
    onSuccessLoc = (pos) =>
      User.latitude = pos.coords.latitude
      User.longitude = pos.coords.longitude
      @trigger 'location_success'

    onErrorLoc = ->
      @trigger 'location_failure'

    options =
      enableHighAccuracy: false
      timeout: 4000
      maximumAge: 30000

    navigatorSupported = typeof navigator isnt 'undefined'
    if navigatorSupported
      navigator.geolocation.watchPosition onSuccessLoc, onErrorLoc, options
    else
      onErrorLoc()

  fetchFacebookInfo: (next) ->
    FB.api '/me/?fields=id,name,picture', (response) =>
      User.facebookID = response.id
      User.name = response.name
      User.profilePicture = response.picture.data.url
      next()

  # Login to Facebook, then HawkerHub
  onLogin: ->
    callback = (response) =>
      if (response.status is 'connected')
        @trigger 'fb_login_success'
        url = App.urlFor 'users/login'
        @fetchFacebookInfo =>
          $.ajax
            type: 'POST'
            url: url
            success: =>
              User.isLoggedIn = true
              @trigger 'hub_login_success'
            error: (e) =>
              @trigger 'hub_login_failure'
      else
        @trigger 'fb_login_failure'

    FB.login callback,
      scope: 'publish_actions,user_friends'

  # Logout from HawkerHub
  onLogout: () ->
    url = App.urlFor 'users/logout'
    $.ajax
      type: 'GET'
      url: url
      success: =>
        User.isLoggedIn = false
        @trigger 'hub_logout_success'
      error: =>
        @trigger 'hub_logout_failure'

  # Check user status,
  onStatus: ->
    FB.getLoginStatus (response) =>
      if response.status is 'connected'
        @trigger 'fb_login_success'
        url = App.urlFor 'users/login'
        $.ajax
          type: 'GET'
          url: url
          success: (data) =>
            if data.Status is 'Already logged in.'
              User.isLoggedIn = true
              @fetchFacebookInfo => @trigger 'hub_login_success'

module.exports = { UserAction, UserStore, User }
