$          = require 'jquery'
_          = require 'lodash'
URL        = require 'url'
App        = require 'ampersand-app'
Collection = require 'ampersand-rest-collection'
Model      = require 'ampersand-model'
Reflux     = require 'reflux'

UserAction = Reflux.createActions ['status', 'login', 'logout']

User = { isLoggedIn: false }

UserStore = Reflux.createStore
  listenables: UserAction

  getLoginStatus: -> User.isLoggedIn
  getName: -> User.name
  getProfilePicture: -> User.profilePicture

  onLogin: (options) ->
    callback = (response) =>
      @trigger { name: 'status', value: response.status }
      url = App.urlFor 'users/login'
      $.ajax
        type: 'GET'
        url: url
        success: (data) =>
          @trigger { name: 'status', value: response.status }

    FB.login callback,
      scope: 'publish_actions,friends'
      return_scopes: true

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
      if (response.status is 'connected')
        FB.api '/me/?fields=id,name,picture', (response2) =>
          User.id = response2.id
          User.name = response2.name
          User.profilePicture = response2.picture.data.url
          @trigger { name: 'status', value: response.status }

module.exports = { UserAction, UserStore }
