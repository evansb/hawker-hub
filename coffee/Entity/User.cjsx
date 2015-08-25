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
    FB.getLoginStatus (response) =>
      if (response.status isnt 'connected') then FB.login()
      @trigger { name: 'status', value: response.status }

  onLogout: () ->
    FB.logout()
    @trigger { name: 'status', value: 'logged_out'}

  onStatus: ->
    FB.getLoginStatus (response) =>
      User.isLoggedIn = response.status is 'connected'
      url = "#{App.urlFor 'users'}/login"
      FB.api '/me/?fields=id,name,picture', (response2) =>
        User.id = response2.id
        User.name = response2.name
        User.profilePicture = response2.picture.url
        console.log(response2)
        @trigger { name: 'status', value: response.status }

  onLogout: (options) ->

module.exports = { UserAction, UserStore }
