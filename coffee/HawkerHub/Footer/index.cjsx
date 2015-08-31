$             = require 'jquery'
React         = require 'react'
UI            = require 'material-ui'
Image         = require 'react-retina-image'
UITheme       = require '../Common/UITheme'
Icon          = require '../Common/MaterialIcon'

module.exports = React.createClass
  mixins: [UITheme]
  componentDidMount: ->
    if ($(window).height() > $('body').height())
      $(React.findDOMNode(this)).css('position','absolute').css('bottom',0)

  render: ->
    <footer>
      <div className="row">
        <UI.FlatButton label="Privacy" />
        <UI.FlatButton label="API" />
        <UI.FlatButton label="About Us" />
      </div>
      <div className="row">
          &copy; 2015 Proudly crafted by the HawkerHub team.<br/>
          All rights reserved.
      </div>
    </footer>
