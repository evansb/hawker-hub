$             = require 'jquery'
React         = require 'react'
UI            = require 'material-ui'
Image         = require 'react-retina-image'
UITheme       = require '../Common/UITheme'
Icon          = require '../Common/MaterialIcon'

LikeButton = React.createClass
  componentDidMount: ->
  render: ->
    <div className="fb-like"
         data-href="http://#{window.API_HOST}"
         data-layout="standard"
         data-action="like"
         data-show-faces="true">
    </div>

module.exports = React.createClass
  mixins: [UITheme]
  render: ->
    <footer>
      <div className="row">
        <LikeButton />
        <UI.FlatButton label="Privacy" />
        <UI.FlatButton label="API" />
        <UI.FlatButton label="About Us" />
      </div>
      <div className="row">
          &copy; 2015 Proudly crafted by the HawkerHub team.<br/>
      </div>
    </footer>
