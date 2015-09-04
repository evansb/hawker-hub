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
      data-href="https://www.facebook.com/hawkerhub"
      data-layout="button_count"
      data-action="like"
      data-show-faces="true"
      data-share="true">
    </div>

module.exports = React.createClass
  mixins: [UITheme]
  render: ->
    <footer>
      <div className="row footer-bar">
        <div className="nine columns">
          <h2>"What's nice to eat nearby?"</h2>
          <p>
            HawkerHub recommends you your friends&lsquo; favorite food based on your location. <br/>
            Stop getting confused and start using HawkerHub.
          </p>
          <LikeButton />
        </div>
        <div className="row">
          <div className="three columns footer-div">
            <div className="row">
              <a className="footer-button">Privacy</a>
            </div>
            <div className="row">
              <a className="footer-button">API</a>
            </div>
            <div className="row">
              <a className="footer-button">About Us</a>
            </div>
          </div>
        </div>
        <div className="row" style={{textAlign:'center'}}>
          <br/>
          &copy; 2015 Proudly crafted by the HawkerHub team.<br/>
          <br/>
        </div>
      </div>


    </footer>
