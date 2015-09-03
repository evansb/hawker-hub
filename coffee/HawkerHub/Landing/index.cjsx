React = require 'react'
UI = require 'material-ui'
UITheme= require '../Common/UITheme'
{User, UserAction} = require '../../Entity/User'

module.exports = React.createClass
  mixins: [UITheme]
  render: ->
    label = if @props.fbLogin then "Continue Login" else "Login Using Facebook"
    <div className="landing">
      <div className="row container logo">
        <img src="../../../assets/landing_centre_image.png" />
      </div>
      <div className="row container login">
        { if @props.fbLogin
            <div className="welcome-back">
              <UI.Avatar size={56} src={User.profilePicture} />
              {User.name}
            </div> }
        <button className="button" onClick={-> UserAction.login()} >
          {label}
        </button>
        { if @props.fbLogin
          <button className="button" onClick={-> FB.logout() && location.reload() } >
            {"Not #{User.name} ?"}
          </button>
        }
      </div>
    </div>
