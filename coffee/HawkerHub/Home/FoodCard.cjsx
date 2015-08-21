React       = require 'react'
UI          = require 'material-ui'
UITheme     = require '../Common/UITheme'
Icon        = require '../Common/MaterialIcon'
$           = require 'jquery'
{ Cell }    = require 'react-pure'

FoodHeaderOverlay = React.createClass
  render: ->
    <Cell>
      <Cell size='5/6'>
        <div className='food-card-title'>Title</div>
        <div className='food-card-subtitle'>Subtitle</div>
      </Cell>
      <Cell size='1/6'>
        <Cell size='1/2'>
          <Icon name="favorite_border" overrideColor="white"></Icon>
        </Cell>
        <Cell size='1/2'>
          <Icon name="more_vert" overrideColor="white"></Icon>
        </Cell>
      </Cell>
    </Cell>

FoodHeader = React.createClass
  mixins: [UITheme]
  getInitialState: ->
    imageLoaded: false
  componentWillMount: ->
    # Fetch image Asynchronously
    url = "http://lorempixel.com/600/337/nature/"
    image = $("<img />").attr('src', url)
    image.load =>
      @setState { imageLoaded: true }
      $(React.findDOMNode(@refs.picture)).html image
  render: ->
    <UI.CardMedia overlay={<FoodHeaderOverlay />} className="food-card-image">
      <div ref="picture">
        { <UI.CircularProgress mode="indeterminate" /> unless @state.imageLoaded }
      </div>
    </UI.CardMedia>

module.exports = React.createClass
  mixins: [UITheme]
  propTypes:
    headerOnly: React.PropTypes.bool
  render: ->
    <UI.Card>
      <FoodHeader />
    </UI.Card>
