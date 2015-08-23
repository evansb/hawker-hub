App = require 'ampersand-app'
URL = require 'url'

App.extend
  title: -> 'Hawker Hub'
  version: -> '0.0.1'
  apiVersion: -> 'v1'
  urlFor: (url) ->
    base = URL.resolve '/api', @apiVersion()
    URL.resolve base, url
