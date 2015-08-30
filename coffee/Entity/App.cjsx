App = require 'ampersand-app'
URL = require 'url'

App.extend
  title: -> 'Hawker Hub'
  version: -> '0.0.1'
  apiVersion: -> 'v1'
  urlFor: (resourceName, params) ->
    URL.format
      protocol: 'http'
      hostname: "#{API_HOST}/api/v1"
      pathname: resourceName
      query: params
  withLocation: (callback) ->
    navigator.geolocation.getCurrentPosition (position) ->
      callback(position.coords.latitude, position.coords.longitude)
