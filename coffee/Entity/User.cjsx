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

  fetchUserInfo: ->
    FB.api '/me/?fields=id,name,picture', (response2) =>
      User.id = response2.id
      User.name = response2.name
      User.profilePicture = response2.picture.data.url
      @trigger { name: 'status', value: 'connected' }

  onLogin: (options) ->
    callback = (response) =>
      url = App.urlFor 'users/login'
      $.ajax
        type: 'GET'
        url: url
        success: => @fetchUserInfo()
    FB.login callback,
      scope: 'publish_actions,user_friends'
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
      url = App.urlFor 'users/login'
      $.ajax { type: 'GET', url: url }
      @fetchUserInfo() if User.isLoggedIn

module.exports = { UserAction, UserStore }
