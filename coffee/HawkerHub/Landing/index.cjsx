React = require 'react'
UI = require 'material-ui'
UITheme= require '../Common/UITheme'

module.exports = React.createClass
  mixins: [UITheme]
  render: ->
    <div className="landing">
      <div className="row container logo">
        <img src="../../../assets/landing_centre_image.png" />
      </div>
      <div className="row container login">
        <UI.RaisedButton label="Login using Facebook"></UI.RaisedButton>
      </div>
    </div>
