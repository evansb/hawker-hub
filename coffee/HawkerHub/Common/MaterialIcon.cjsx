React      = require 'react'
UI         = require 'material-ui'
UITheme    = require './UITheme'

module.exports = React.createClass
  mixins: [UITheme]
  render: ->
    <UI.IconButton tooltip={@props.tooltip} touch={true}
                   onClick={@props.onClick}>
      <UI.FontIcon className="material-icons" color={@props.overrideColor}>
        {@props.name}
      </UI.FontIcon>
    </UI.IconButton>
