Reflux       = require 'reflux'
{UserAction} = require './User'

initFB = (d, s, id) ->
  fjs = d.getElementsByTagName(s)[0]
  if (d.getElementById(id)) then return
  js = d.createElement(s)
  js.id = id
  js.src = '//connect.facebook.net/en_US/sdk.js'
  fjs.parentNode.insertBefore js, fjs

FacebookStore = Reflux.createStore
  init: ->
    window.fbAsyncInit = =>
      FB.init
        appId: '1466024120391100'
        version: 'v2.4'
        xfbml: true
        cookie: true  
      FB.XFBML.parse()
      @trigger 'ready'
    initFB(document, 'script', 'facebook-jssdk')

module.exports = { FacebookStore }
