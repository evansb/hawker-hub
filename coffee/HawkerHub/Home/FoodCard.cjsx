React       = require 'react'
UI          = require 'material-ui'
UITheme     = require '../Common/UITheme'
Icon        = require '../Common/MaterialIcon'
$           = require 'jquery'

FoodHeaderOverlay = React.createClass
  render: ->
    <div className='row'>
      <div className='one column'>
        <Icon name="add" overrideColor="white"></Icon>
      </div>
      <div className='nine columns'>
        <strong className='food-card-title'>Title</strong>
        <div className='food-card-subtitle'>Subtitle</div>
      </div>
      <div className='one column'>
        <Icon name="more_vert" overrideColor="white"
              onClick={@props.handleMoreClick}></Icon>
      </div>
    </div>

module.exports = React.createClass
  mixins: [UITheme]
  propTypes:
    handleMoreClick: React.PropTypes.func.isRequired
  getInitialState: ->
    imageLoaded: false
  componentWillMount: ->
    url = "http://lorempixel.com/#{ 500 + Math.floor(Math.random() * 40)}/337/food/"
    image = $("<img class='u-full-width u-max-full-width u-max-full-height' />")
            .attr('src', url)
    $(image).click => @props.handleMoreClick()
    image.load =>
      @setState { imageLoaded: true }
      $(React.findDOMNode(@refs.picture)).html image
  render: ->
    overlay = <FoodHeaderOverlay handleMoreClick={@props.handleMoreClick} />
    <UI.CardMedia overlay={overlay} className="food-card">
      <div ref="picture" className="food-card-progress">
        <UI.LinearProgress className="food-card-progress-bar"/>
      </div>
    </UI.CardMedia>
