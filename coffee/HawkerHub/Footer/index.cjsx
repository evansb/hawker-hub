React         = require 'react'
UI            = require 'material-ui'
Image         = require 'react-retina-image'
UITheme       = require '../Common/UITheme'
Icon          = require '../Common/MaterialIcon'

module.exports = React.createClass
  mixins: [UITheme]
  render: ->
    <div>
      <div className="row">
        <UI.FlatButton label="Landing" />
        <UI.FlatButton label="Privacy" />
        <UI.FlatButton label="API" />  
        <UI.FlatButton label="About Us" />
      </div>
      <div className="row">
          &copy; 2015 Proudly crafted by HawkerHub team <br/>
          All rights reserved
      </div>
    </div>
