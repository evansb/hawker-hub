React = require 'react'
$     = require 'jquery'

APIStatus = React.createClass
  getInitialState: ->
    status: "Down"

  componentDidMount: ->
    $.ajax
      url: 'api/v1'
      success: =>
        @setState { status: "Running" }

  render: ->
    <p>API is { @state.status }</p>

module.exports = React.createClass
  render: ->
    <div>
      <h2>Welcome to HawkerHub</h2>
      <APIStatus />
    </div>
