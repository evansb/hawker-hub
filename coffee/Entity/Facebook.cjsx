{UserAction} = require './User'

window.fbAsyncInit = ->
  FB.init
    appId: '1466024120391100'
    version: 'v2.4'
    xfbml: true
    cookie: true
  UserAction.status()
  FB.XFBML.parse()

initFB = (d, s, id) ->
  fjs = d.getElementsByTagName(s)[0]
  if (d.getElementById(id)) then return
  js = d.createElement(s)
  js.id = id
  js.src = '//connect.facebook.net/en_US/sdk.js'
  fjs.parentNode.insertBefore js, fjs

initFB(document, 'script', 'facebook-jssdk')
