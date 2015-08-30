React       = require 'react'
Image       = require 'react-retina-image'
UI          = require 'material-ui'
UITheme     = require '../Common/UITheme'
Icon        = require '../Common/MaterialIcon'
$           = require 'jquery'

FoodHeaderOverlay = React.createClass
  render: ->
    <div className='row'>
      <strong className='food-card-title'>{@props.model.itemName}</strong>
    </div>

module.exports = React.createClass
  mixins: [UITheme]
  propTypes:
    handleMoreClick: React.PropTypes.func.isRequired
  getInitialState: ->
    imageLoaded: false
  render: ->
    overlay = <FoodHeaderOverlay model={@props.model} />
    <UI.Paper className="food-card"
              onClick={=> @props.handleMoreClick(@props.model)}>
      <UI.CardMedia overlay={overlay}>
        <div ref="picture" className="food-card-progress">
          <Image className="u-full-width u-max-full-width u-max-full-height"
                 src={@props.model.photoURL} />
        </div>
      </UI.CardMedia>
    </UI.Paper>
