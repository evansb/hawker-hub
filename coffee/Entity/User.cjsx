$          = require 'jquery'
_          = require 'lodash'
URL        = require 'url'
App        = require 'ampersand-app'
Collection = require 'ampersand-collection'
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

watchId = null

# User Store as event hub
UserStore = Reflux.createStore
  listenables: UserAction

  onWatch: (cb) ->
    onSuccessLoc = (pos) =>
      User.latitude = pos.coords.latitude
      User.longitude = pos.coords.longitude
      if cb then cb(User.latitude, User.longitude)
      @trigger 'location_success'

    onErrorLoc = =>
      @trigger 'location_failure'

    options =
      enableHighAccuracy: true
      timeout: 4000
      maximumAge: 30000

    navigatorSupported = typeof navigator isnt 'undefined'
    if navigatorSupported
      watchId = navigator.geolocation.getCurrentPosition onSuccessLoc, onErrorLoc, options
    else
      onErrorLoc()

  onStopWatch: ->
    navigatorSupported = typeof navigator isnt 'undefined'
    if navigatorSupported
      navigator.geolocation.clearWatch watchId
      @trigger 'location_cleared'

  fetchFacebookInfo: (next) ->
    FB.api '/me/?fields=id,name,picture', (response) =>
      User.id = response.id
      User.name = response.name
      User.profilePicture = response.picture.data.url
      next()

  # Login to Facebook, then HawkerHub
  onLogin: ->
    callback = (response) =>
      if (response.status is 'connected')
        url = App.urlFor 'users/login'
        @fetchFacebookInfo =>
          @trigger 'fb_login_success'
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
            else
              @fetchFacebookInfo => @trigger 'fb_login_success'

module.exports = { UserAction, UserStore, User }
