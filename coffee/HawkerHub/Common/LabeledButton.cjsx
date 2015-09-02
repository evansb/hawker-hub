UI = require 'material-ui'
React = require 'react'

module.exports = React.createClass
  render: ->
    child =
      <div className="row button-content">
        <div className="four columns button-icon">
          <UI.FontIcon className="material-icons">{@props.icon}</UI.FontIcon>
        </div>
        <div className="eight columns button-text">{@props.label}</div>
      </div>
    <UI.FlatButton onClick={@props.onClick} children={child} />
