React = require 'react'
$ = require 'jquery'
App = require './app'

$(->
  React.render <App />, document.getElementById('main'))
